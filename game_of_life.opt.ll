; ModuleID = '/home/cable/Projects/oxide-cuda/game_of_life/game_of_life.ll'
source_filename = "game_of_life"
target datalayout = "e-i64:64-i128:128-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

; Function Attrs: convergent mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite, inaccessiblemem: write)
define ptx_kernel void @vecadd(ptr readonly captures(none) %v0, i64 %v1, ptr readonly captures(none) %v2, i64 %v3, ptr writeonly captures(none) %v4, i64 %v5) local_unnamed_addr #0 {
entry:
  %v2.i = tail call i32 @llvm.nvvm.read.ptx.sreg.tid.x() #4
  %v3.i = zext nneg i32 %v2.i to i64
  %v4.i = tail call i32 @llvm.nvvm.read.ptx.sreg.ctaid.x() #4
  %v5.i = zext nneg i32 %v4.i to i64
  %v6.i = tail call i32 @llvm.nvvm.read.ptx.sreg.ntid.x() #4
  %v7.i = zext nneg i32 %v6.i to i64
  %v8.i = mul nuw nsw i64 %v5.i, %v7.i
  %v9.i = add nuw nsw i64 %v8.i, %v3.i
  %v19.not = icmp ult i64 %v9.i, %v5
  br i1 %v19.not, label %bb2, label %bb6

bb2:                                              ; preds = %entry
  %v34 = getelementptr inbounds nuw float, ptr %v4, i64 %v9.i
  %v23 = icmp ult i64 %v9.i, %v1
  tail call void @llvm.assume(i1 %v23)
  %v25 = getelementptr inbounds nuw float, ptr %v0, i64 %v9.i
  %v26 = load float, ptr %v25, align 4
  %v28 = icmp ult i64 %v9.i, %v3
  tail call void @llvm.assume(i1 %v28)
  %v30 = getelementptr inbounds nuw float, ptr %v2, i64 %v9.i
  %v31 = load float, ptr %v30, align 4
  %v32 = fadd float %v26, %v31
  store float %v32, ptr %v34, align 4
  br label %bb6

bb6:                                              ; preds = %entry, %bb2
  ret void
}

; Function Attrs: convergent mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite, inaccessiblemem: write)
define ptx_kernel void @gol(i64 %v0, i64 %v1, ptr readonly captures(none) %v2, i64 %v3, ptr writeonly captures(none) %v4, i64 %v5) local_unnamed_addr #0 {
entry:
  %v2.i = tail call i32 @llvm.nvvm.read.ptx.sreg.tid.x() #4
  %v3.i = zext nneg i32 %v2.i to i64
  %v4.i = tail call i32 @llvm.nvvm.read.ptx.sreg.ctaid.x() #4
  %v5.i = zext nneg i32 %v4.i to i64
  %v6.i = tail call i32 @llvm.nvvm.read.ptx.sreg.ntid.x() #4
  %v7.i = zext nneg i32 %v6.i to i64
  %v8.i = mul nuw nsw i64 %v5.i, %v7.i
  %v9.i = add nuw nsw i64 %v8.i, %v3.i
  %v0.frozen = freeze i64 %v0
  %v19 = udiv i64 %v9.i, %v0.frozen
  %0 = mul i64 %v19, %v0.frozen
  %v20.decomposed = sub i64 %v9.i, %0
  %v21.not = icmp ult i64 %v19, %v1
  br i1 %v21.not, label %bb5, label %bb59

bb5:                                              ; preds = %entry
  %v25 = mul i64 %v20.decomposed, %v0
  %v26 = add i64 %v25, %v19
  %v28 = icmp ult i64 %v26, %v3
  tail call void @llvm.assume(i1 %v28)
  %v30 = getelementptr inbounds i8, ptr %v2, i64 %v26
  %v31 = load i8, ptr %v30, align 1
  %v32.not = icmp ugt i64 %v0, %v9.i
  %v34.not = icmp eq i64 %v20.decomposed, 0
  %or.cond1 = or i1 %v32.not, %v34.not
  br i1 %or.cond1, label %bb12, label %bb8

bb8:                                              ; preds = %bb5
  %v36 = add nsw i64 %v20.decomposed, -1
  %v37 = mul i64 %v36, %v0
  %v38 = add nsw i64 %v19, -1
  %v39 = add i64 %v38, %v37
  %v40 = icmp ult i64 %v39, %v3
  tail call void @llvm.assume(i1 %v40)
  %v42 = getelementptr inbounds i8, ptr %v2, i64 %v39
  %v43 = load i8, ptr %v42, align 1
  %v44 = icmp eq i8 %v43, 1
  %spec.select4 = zext i1 %v44 to i32
  br label %bb12

bb12:                                             ; preds = %bb8, %bb5
  %v46 = phi i32 [ 0, %bb5 ], [ %spec.select4, %bb8 ]
  br i1 %v32.not, label %bb17, label %bb13

bb13:                                             ; preds = %bb12
  %v48 = add nsw i64 %v19, -1
  %v49 = add i64 %v48, %v25
  %v50 = icmp ult i64 %v49, %v3
  tail call void @llvm.assume(i1 %v50)
  %v52 = getelementptr inbounds i8, ptr %v2, i64 %v49
  %v53 = load i8, ptr %v52, align 1
  %v54 = icmp eq i8 %v53, 1
  %v55 = zext i1 %v54 to i32
  %spec.select5 = add nuw nsw i32 %v46, %v55
  br label %bb17

bb17:                                             ; preds = %bb13, %bb12
  %v56 = phi i32 [ %v46, %bb12 ], [ %spec.select5, %bb13 ]
  br i1 %v32.not, label %bb23, label %bb18

bb18:                                             ; preds = %bb17
  %v58 = add nuw nsw i64 %v20.decomposed, 1
  %v59.not = icmp samesign ult i64 %v58, %v0
  br i1 %v59.not, label %bb19, label %bb23

bb19:                                             ; preds = %bb18
  %v61 = mul i64 %v58, %v0
  %v62 = add nsw i64 %v19, -1
  %v63 = add i64 %v62, %v61
  %v64 = icmp ult i64 %v63, %v3
  tail call void @llvm.assume(i1 %v64)
  %v66 = getelementptr inbounds i8, ptr %v2, i64 %v63
  %v67 = load i8, ptr %v66, align 1
  %v68 = icmp eq i8 %v67, 1
  %v69 = zext i1 %v68 to i32
  %spec.select6 = add nuw nsw i32 %v56, %v69
  br label %bb23

bb23:                                             ; preds = %bb19, %bb18, %bb17
  %v70 = phi i32 [ %v56, %bb17 ], [ %v56, %bb18 ], [ %spec.select6, %bb19 ]
  br i1 %v34.not, label %bb28, label %bb24

bb24:                                             ; preds = %bb23
  %v73 = add nsw i64 %v20.decomposed, -1
  %v74 = mul i64 %v73, %v0
  %v75 = add i64 %v74, %v19
  %v76 = icmp ult i64 %v75, %v3
  tail call void @llvm.assume(i1 %v76)
  %v78 = getelementptr inbounds i8, ptr %v2, i64 %v75
  %v79 = load i8, ptr %v78, align 1
  %v80 = icmp eq i8 %v79, 1
  %v81 = zext i1 %v80 to i32
  %spec.select7 = add nuw nsw i32 %v70, %v81
  br label %bb28

bb28:                                             ; preds = %bb24, %bb23
  %v82 = phi i32 [ %v70, %bb23 ], [ %spec.select7, %bb24 ]
  %v83 = add nuw nsw i64 %v20.decomposed, 1
  %v84 = icmp uge i64 %v83, %v0
  br i1 %v84, label %bb33, label %bb29

bb29:                                             ; preds = %bb28
  %v86 = mul i64 %v83, %v0
  %v87 = add i64 %v86, %v19
  %v88 = icmp ult i64 %v87, %v3
  tail call void @llvm.assume(i1 %v88)
  %v90 = getelementptr inbounds i8, ptr %v2, i64 %v87
  %v91 = load i8, ptr %v90, align 1
  %v92 = icmp eq i8 %v91, 1
  %v93 = zext i1 %v92 to i32
  %spec.select8 = add nuw nsw i32 %v82, %v93
  br label %bb33

bb33:                                             ; preds = %bb29, %bb28
  %v94 = phi i32 [ %v82, %bb28 ], [ %spec.select8, %bb29 ]
  %v95 = add nuw nsw i64 %v19, 1
  %v96 = icmp uge i64 %v95, %v1
  %or.cond2 = or i1 %v96, %v34.not
  br i1 %or.cond2, label %bb39, label %bb35

bb35:                                             ; preds = %bb33
  %v99 = add nsw i64 %v20.decomposed, -1
  %v100 = mul i64 %v99, %v0
  %v101 = add i64 %v100, %v95
  %v102 = icmp ult i64 %v101, %v3
  tail call void @llvm.assume(i1 %v102)
  %v104 = getelementptr inbounds i8, ptr %v2, i64 %v101
  %v105 = load i8, ptr %v104, align 1
  %v106 = icmp eq i8 %v105, 1
  %v107 = zext i1 %v106 to i32
  %spec.select9 = add nuw nsw i32 %v94, %v107
  br label %bb39

bb39:                                             ; preds = %bb35, %bb33
  %v108 = phi i32 [ %v94, %bb33 ], [ %spec.select9, %bb35 ]
  br i1 %v96, label %bb44, label %bb40

bb40:                                             ; preds = %bb39
  %v110 = add i64 %v25, %v95
  %v111 = icmp ult i64 %v110, %v3
  tail call void @llvm.assume(i1 %v111)
  %v113 = getelementptr inbounds i8, ptr %v2, i64 %v110
  %v114 = load i8, ptr %v113, align 1
  %v115 = icmp eq i8 %v114, 1
  %v116 = zext i1 %v115 to i32
  %spec.select10 = add nuw nsw i32 %v108, %v116
  br label %bb44

bb44:                                             ; preds = %bb40, %bb39
  %v117 = phi i32 [ %v108, %bb39 ], [ %spec.select10, %bb40 ]
  %or.cond3 = or i1 %v96, %v84
  br i1 %or.cond3, label %bb50, label %bb46

bb46:                                             ; preds = %bb44
  %v120 = mul i64 %v83, %v0
  %v121 = add i64 %v120, %v95
  %v122 = icmp ult i64 %v121, %v3
  tail call void @llvm.assume(i1 %v122)
  %v124 = getelementptr inbounds i8, ptr %v2, i64 %v121
  %v125 = load i8, ptr %v124, align 1
  %v126 = icmp eq i8 %v125, 1
  %v127 = zext i1 %v126 to i32
  %spec.select11 = add nuw nsw i32 %v117, %v127
  br label %bb50

bb50:                                             ; preds = %bb46, %bb44
  %v128 = phi i32 [ %v117, %bb44 ], [ %spec.select11, %bb46 ]
  %v134.not = icmp ult i64 %v9.i, %v5
  br i1 %v134.not, label %bb56, label %bb59

bb56:                                             ; preds = %bb50
  %v129 = icmp eq i8 %v31, 1
  %1 = and i32 %v128, -2
  %2 = icmp eq i32 %1, 2
  %v130 = icmp eq i32 %v128, 3
  %v132.in = select i1 %v129, i1 %2, i1 %v130
  %v132 = zext i1 %v132.in to i8
  %v138 = getelementptr inbounds nuw i8, ptr %v4, i64 %v9.i
  store i8 %v132, ptr %v138, align 1
  br label %bb59

bb59:                                             ; preds = %bb50, %bb56, %entry
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.nvvm.read.ptx.sreg.tid.x() #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 2147483647) i32 @llvm.nvvm.read.ptx.sreg.ctaid.x() #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 1, 1025) i32 @llvm.nvvm.read.ptx.sreg.ntid.x() #1

; Function Attrs: convergent mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define range(i64 0, 2199023254528) i64 @cuda_device____internal__index_1d(ptr readnone captures(none) %v0) local_unnamed_addr #2 {
entry:
  %v2 = tail call i32 @llvm.nvvm.read.ptx.sreg.tid.x() #4
  %v3 = zext nneg i32 %v2 to i64
  %v4 = tail call i32 @llvm.nvvm.read.ptx.sreg.ctaid.x() #4
  %v5 = zext nneg i32 %v4 to i64
  %v6 = tail call i32 @llvm.nvvm.read.ptx.sreg.ntid.x() #4
  %v7 = zext nneg i32 %v6 to i64
  %v8 = mul nuw nsw i64 %v5, %v7
  %v9 = add nuw nsw i64 %v8, %v3
  ret i64 %v9
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #3

attributes #0 = { convergent mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite, inaccessiblemem: write) }
attributes #1 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { convergent mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #4 = { convergent }
