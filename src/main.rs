use cuda_core::{CudaContext, DeviceBuffer, LaunchConfig};
use cuda_device::{DisjointSlice, kernel, thread};
use cuda_host::cuda_module;
use rand::RngExt;

use std::time::Instant;

macro_rules! flatten_index {
    ($x:expr, $y:expr, $width:expr) => {
        ($y * $width) + $x
    };
}

#[cuda_module]
mod kernels {

    use super::*;

    #[kernel]
    pub fn vecadd(a: &[f32], b: &[f32], mut c: DisjointSlice<f32>) {
        let idx = thread::index_1d();
        let idx_raw = idx.get();
        if let Some(c_elem) = c.get_mut(idx) {
            *c_elem = a[idx_raw] + b[idx_raw];
        }
    }
    #[kernel]
    pub fn gol(
        width: usize,
        height: usize,
        current_state: &[u8],
        mut output_state: DisjointSlice<u8>,
    ) {
        let idx = thread::index_1d();

        let i = idx.get();

        let row = i / width;
        let col = i % width;

        if row >= height || col >= width {
            return;
        }

        let center_idx = flatten_index!(row, col, width);
        let center_val = current_state[center_idx];

        let mut sum = 0;

        // Top Left
        if row >= 1 && col >= 1 && current_state[flatten_index!(row - 1, col - 1, width)] == 1 {
            sum += 1;
        }

        // Top Middle
        if row >= 1 && current_state[flatten_index!(row - 1, col, width)] == 1 {
            sum += 1;
        }

        // Top Right
        if row >= 1
            && col + 1 < width
            && current_state[flatten_index!(row - 1, col + 1, width)] == 1
        {
            sum += 1;
        }

        // Middle Left
        if col >= 1 && current_state[flatten_index!(row, col - 1, width)] == 1 {
            sum += 1;
        }

        // Middle Right
        if col + 1 < width && current_state[flatten_index!(row, col + 1, width)] == 1 {
            sum += 1;
        }

        // Bottom Left
        if row + 1 < height
            && col >= 1
            && current_state[flatten_index!(row + 1, col - 1, width)] == 1
        {
            sum += 1;
        }

        // Bottom Middle
        if row + 1 < height && current_state[flatten_index!(row + 1, col, width)] == 1 {
            sum += 1;
        }

        // Bottom Right
        if row + 1 < height
            && col + 1 < width
            && current_state[flatten_index!(row + 1, col + 1, width)] == 1
        {
            sum += 1;
        }

        let next_val = match (center_val, sum) {
            (1, 2) | (_, 3) => 1,
            _ => 0,
        };

        if let Some(out_elem) = output_state.get_mut(idx) {
            *out_elem = next_val;
        }
    }
}
fn main() {
    let ctx = CudaContext::new(0).expect("Failed to create CUDA context");
    let stream = ctx.default_stream();

    const N: usize = 1024;
    const GENERATIONS: usize = 1000;

    let mut rng = rand::rng();
    let gol_current: Vec<u8> = (0..(N * N))
        .map(|_| if rng.random::<bool>() { 1 } else { 0 })
        .collect();

    let mut dev_a = DeviceBuffer::from_host(&stream, &gol_current).unwrap();
    let mut dev_b = DeviceBuffer::<u8>::zeroed(&stream, N * N).unwrap();

    let gol_mod = kernels::load(&ctx).expect("Failed to load embedded CUDA module");
    let launch_cfg = LaunchConfig::for_num_elems((N * N) as u32);

    println!("Simulating {} generations...", GENERATIONS);

    let start_time = Instant::now();

    for i in 0..GENERATIONS {
        if i % 2 == 0 {
            gol_mod
                .gol(&stream, launch_cfg, N, N, &dev_a, &mut dev_b)
                .expect("Kernel failed to launch.");
        } else {
            gol_mod
                .gol(&stream, launch_cfg, N, N, &dev_b, &mut dev_a)
                .expect("Kernel failed to launch.");
        }
    }

    stream.synchronize().expect("Failed to synchronize stream.");

    let duration = start_time.elapsed();

    // 5. Calculate some fun statistics
    let total_secs = duration.as_secs_f64();
    let generations_per_sec = GENERATIONS as f64 / total_secs;

    println!("=====================================");
    println!("Simulation Complete!");
    println!("Total Time:       {:.4} seconds", total_secs);
    println!(
        "Time per Gen:     {:.4} milliseconds",
        (total_secs * 1000.0) / GENERATIONS as f64
    );
    println!(
        "Speed:            {:.0} generations/second",
        generations_per_sec
    );
    println!("=====================================");
    let final_buffer = if GENERATIONS % 2 == 0 { &dev_a } else { &dev_b };

    let out_host = final_buffer.to_host_vec(&stream).unwrap();
    println!("Generating image...");

    let pixel_data: Vec<u8> = out_host
        .into_iter()
        .map(|cell| if cell == 1 { 255 } else { 0 })
        .collect();

    let img = image::GrayImage::from_raw(N as u32, N as u32, pixel_data)
        .expect("Failed to create image buffer");

    img.save("gol_final.png").expect("Failed to save image");
    println!("Saved final state to 'gol_final.png'!");
}
