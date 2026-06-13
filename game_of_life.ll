; ModuleID = 'builtin.module'
source_filename = "game_of_life"
target datalayout = "e-i64:64-i128:128-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

define ptx_kernel void @vecadd(ptr %v0, i64 %v1, ptr %v2, i64 %v3, ptr %v4, i64 %v5) #0 {
entry:
  %v6 = insertvalue { ptr, i64 } undef, ptr %v0, 0
  %v7 = insertvalue { ptr, i64 } %v6, i64 %v1, 1
  %v8 = insertvalue { ptr, i64 } undef, ptr %v2, 0
  %v9 = insertvalue { ptr, i64 } %v8, i64 %v3, 1
  %v10 = insertvalue { ptr, i64 } undef, ptr %v4, 0
  %v11 = insertvalue { ptr, i64 } %v10, i64 %v5, 1
  br label %bb0
bb0:
  %v12 = phi { ptr, i64 } [ %v7, %entry ]
  %v13 = phi { ptr, i64 } [ %v9, %entry ]
  %v14 = phi { ptr, i64 } [ %v11, %entry ]
  %v15 = alloca {  }, align 1
  %v16 = bitcast ptr %v15 to ptr
  %v17 = call i64 @cuda_device____internal__index_1d(ptr %v16) #0
  br label %bb1
bb1:
  %v18 = extractvalue { ptr, i64 } %v14, 1
  %v19 = icmp ult i64 %v17, %v18
  %v20 = xor i1 %v19, 1
  br i1 %v20, label %bb8, label %bb7
bb2:
  %v21 = extractvalue { i8, ptr } %v38, 1
  %v22 = extractvalue { ptr, i64 } %v12, 1
  %v23 = icmp ult i64 %v17, %v22
  br i1 %v23, label %bb3, label %bb12
bb3:
  %v24 = extractvalue { ptr, i64 } %v12, 0
  %v25 = getelementptr inbounds float, ptr %v24, i64 %v17
  %v26 = load float, ptr %v25, align 4
  %v27 = extractvalue { ptr, i64 } %v13, 1
  %v28 = icmp ult i64 %v17, %v27
  br i1 %v28, label %bb4, label %bb13
bb4:
  %v29 = extractvalue { ptr, i64 } %v13, 0
  %v30 = getelementptr inbounds float, ptr %v29, i64 %v17
  %v31 = load float, ptr %v30, align 4
  %v32 = fadd float %v26, %v31
  store float %v32, ptr %v21, align 4
  br label %bb6
bb5:
  br label %bb6
bb6:
  ret void
bb7:
  %v33 = extractvalue { ptr, i64 } %v14, 0
  %v34 = getelementptr inbounds float, ptr %v33, i64 %v17
  %v35 = insertvalue { i8, ptr } undef, i8 1, 0
  %v36 = insertvalue { i8, ptr } %v35, ptr %v34, 1
  br label %bb9
bb8:
  %v37 = insertvalue { i8, ptr } undef, i8 0, 0
  br label %bb9
bb9:
  %v38 = phi { i8, ptr } [ %v36, %bb7 ], [ %v37, %bb8 ]
  %v39 = extractvalue { i8, ptr } %v38, 0
  %v40 = zext i8 %v39 to i64
  %v41 = icmp eq i64 %v40, 1
  br i1 %v41, label %bb2, label %bb10
bb10:
  %v42 = icmp eq i64 %v40, 0
  br i1 %v42, label %bb5, label %bb11
bb11:
  unreachable
bb12:
  unreachable
bb13:
  unreachable
}

define ptx_kernel void @gol(i64 %v0, i64 %v1, ptr %v2, i64 %v3, ptr %v4, i64 %v5) #0 {
entry:
  %v6 = insertvalue { ptr, i64 } undef, ptr %v2, 0
  %v7 = insertvalue { ptr, i64 } %v6, i64 %v3, 1
  %v8 = insertvalue { ptr, i64 } undef, ptr %v4, 0
  %v9 = insertvalue { ptr, i64 } %v8, i64 %v5, 1
  br label %bb0
bb0:
  %v10 = phi i64 [ %v0, %entry ]
  %v11 = phi i64 [ %v1, %entry ]
  %v12 = phi { ptr, i64 } [ %v7, %entry ]
  %v13 = phi { ptr, i64 } [ %v9, %entry ]
  %v14 = alloca {  }, align 1
  %v15 = bitcast ptr %v14 to ptr
  %v16 = call i64 @cuda_device____internal__index_1d(ptr %v15) #0
  br label %bb1
bb1:
  %v17 = icmp eq i64 %v10, 0
  %v18 = xor i1 %v17, 1
  br i1 %v18, label %bb2, label %bb65
bb2:
  %v19 = udiv i64 %v16, %v10
  %v20 = urem i64 %v16, %v10
  %v21 = icmp uge i64 %v19, %v11
  %v22 = xor i1 %v21, 1
  br i1 %v22, label %bb3, label %bb4
bb3:
  %v23 = icmp uge i64 %v20, %v10
  %v24 = xor i1 %v23, 1
  br i1 %v24, label %bb5, label %bb4
bb4:
  br label %bb59
bb5:
  %v25 = mul i64 %v20, %v10
  %v26 = add i64 %v25, %v19
  %v27 = extractvalue { ptr, i64 } %v12, 1
  %v28 = icmp ult i64 %v26, %v27
  br i1 %v28, label %bb6, label %bb66
bb6:
  %v29 = extractvalue { ptr, i64 } %v12, 0
  %v30 = getelementptr inbounds i8, ptr %v29, i64 %v26
  %v31 = load i8, ptr %v30, align 1
  %v32 = icmp uge i64 %v19, 1
  %v33 = xor i1 %v32, 1
  br i1 %v33, label %bb12, label %bb7
bb7:
  %v34 = icmp uge i64 %v20, 1
  %v35 = xor i1 %v34, 1
  br i1 %v35, label %bb12, label %bb8
bb8:
  %v36 = sub i64 %v20, 1
  %v37 = mul i64 %v36, %v10
  %v38 = sub i64 %v19, 1
  %v39 = add i64 %v37, %v38
  %v40 = icmp ult i64 %v39, %v27
  br i1 %v40, label %bb9, label %bb67
bb9:
  %v41 = extractvalue { ptr, i64 } %v12, 0
  %v42 = getelementptr inbounds i8, ptr %v41, i64 %v39
  %v43 = load i8, ptr %v42, align 1
  %v44 = icmp eq i8 %v43, 1
  br i1 %v44, label %bb10, label %bb11
bb10:
  %v45 = add i32 0, 1
  br label %bb12
bb11:
  br label %bb12
bb12:
  %v46 = phi i32 [ 0, %bb6 ], [ 0, %bb7 ], [ %v45, %bb10 ], [ 0, %bb11 ]
  %v47 = xor i1 %v32, 1
  br i1 %v47, label %bb17, label %bb13
bb13:
  %v48 = sub i64 %v19, 1
  %v49 = add i64 %v25, %v48
  %v50 = icmp ult i64 %v49, %v27
  br i1 %v50, label %bb14, label %bb68
bb14:
  %v51 = extractvalue { ptr, i64 } %v12, 0
  %v52 = getelementptr inbounds i8, ptr %v51, i64 %v49
  %v53 = load i8, ptr %v52, align 1
  %v54 = icmp eq i8 %v53, 1
  br i1 %v54, label %bb15, label %bb16
bb15:
  %v55 = add i32 %v46, 1
  br label %bb17
bb16:
  br label %bb17
bb17:
  %v56 = phi i32 [ %v46, %bb12 ], [ %v55, %bb15 ], [ %v46, %bb16 ]
  %v57 = xor i1 %v32, 1
  br i1 %v57, label %bb23, label %bb18
bb18:
  %v58 = add i64 %v20, 1
  %v59 = icmp ult i64 %v58, %v10
  %v60 = xor i1 %v59, 1
  br i1 %v60, label %bb23, label %bb19
bb19:
  %v61 = mul i64 %v58, %v10
  %v62 = sub i64 %v19, 1
  %v63 = add i64 %v61, %v62
  %v64 = icmp ult i64 %v63, %v27
  br i1 %v64, label %bb20, label %bb69
bb20:
  %v65 = extractvalue { ptr, i64 } %v12, 0
  %v66 = getelementptr inbounds i8, ptr %v65, i64 %v63
  %v67 = load i8, ptr %v66, align 1
  %v68 = icmp eq i8 %v67, 1
  br i1 %v68, label %bb21, label %bb22
bb21:
  %v69 = add i32 %v56, 1
  br label %bb23
bb22:
  br label %bb23
bb23:
  %v70 = phi i32 [ %v56, %bb17 ], [ %v56, %bb18 ], [ %v69, %bb21 ], [ %v56, %bb22 ]
  %v71 = icmp uge i64 %v20, 1
  %v72 = xor i1 %v71, 1
  br i1 %v72, label %bb28, label %bb24
bb24:
  %v73 = sub i64 %v20, 1
  %v74 = mul i64 %v73, %v10
  %v75 = add i64 %v74, %v19
  %v76 = icmp ult i64 %v75, %v27
  br i1 %v76, label %bb25, label %bb70
bb25:
  %v77 = extractvalue { ptr, i64 } %v12, 0
  %v78 = getelementptr inbounds i8, ptr %v77, i64 %v75
  %v79 = load i8, ptr %v78, align 1
  %v80 = icmp eq i8 %v79, 1
  br i1 %v80, label %bb26, label %bb27
bb26:
  %v81 = add i32 %v70, 1
  br label %bb28
bb27:
  br label %bb28
bb28:
  %v82 = phi i32 [ %v70, %bb23 ], [ %v81, %bb26 ], [ %v70, %bb27 ]
  %v83 = add i64 %v20, 1
  %v84 = icmp ult i64 %v83, %v10
  %v85 = xor i1 %v84, 1
  br i1 %v85, label %bb33, label %bb29
bb29:
  %v86 = mul i64 %v83, %v10
  %v87 = add i64 %v86, %v19
  %v88 = icmp ult i64 %v87, %v27
  br i1 %v88, label %bb30, label %bb71
bb30:
  %v89 = extractvalue { ptr, i64 } %v12, 0
  %v90 = getelementptr inbounds i8, ptr %v89, i64 %v87
  %v91 = load i8, ptr %v90, align 1
  %v92 = icmp eq i8 %v91, 1
  br i1 %v92, label %bb31, label %bb32
bb31:
  %v93 = add i32 %v82, 1
  br label %bb33
bb32:
  br label %bb33
bb33:
  %v94 = phi i32 [ %v82, %bb28 ], [ %v93, %bb31 ], [ %v82, %bb32 ]
  %v95 = add i64 %v19, 1
  %v96 = icmp ult i64 %v95, %v11
  %v97 = xor i1 %v96, 1
  br i1 %v97, label %bb39, label %bb34
bb34:
  %v98 = xor i1 %v71, 1
  br i1 %v98, label %bb39, label %bb35
bb35:
  %v99 = sub i64 %v20, 1
  %v100 = mul i64 %v99, %v10
  %v101 = add i64 %v100, %v95
  %v102 = icmp ult i64 %v101, %v27
  br i1 %v102, label %bb36, label %bb72
bb36:
  %v103 = extractvalue { ptr, i64 } %v12, 0
  %v104 = getelementptr inbounds i8, ptr %v103, i64 %v101
  %v105 = load i8, ptr %v104, align 1
  %v106 = icmp eq i8 %v105, 1
  br i1 %v106, label %bb37, label %bb38
bb37:
  %v107 = add i32 %v94, 1
  br label %bb39
bb38:
  br label %bb39
bb39:
  %v108 = phi i32 [ %v94, %bb33 ], [ %v94, %bb34 ], [ %v107, %bb37 ], [ %v94, %bb38 ]
  %v109 = xor i1 %v96, 1
  br i1 %v109, label %bb44, label %bb40
bb40:
  %v110 = add i64 %v25, %v95
  %v111 = icmp ult i64 %v110, %v27
  br i1 %v111, label %bb41, label %bb73
bb41:
  %v112 = extractvalue { ptr, i64 } %v12, 0
  %v113 = getelementptr inbounds i8, ptr %v112, i64 %v110
  %v114 = load i8, ptr %v113, align 1
  %v115 = icmp eq i8 %v114, 1
  br i1 %v115, label %bb42, label %bb43
bb42:
  %v116 = add i32 %v108, 1
  br label %bb44
bb43:
  br label %bb44
bb44:
  %v117 = phi i32 [ %v108, %bb39 ], [ %v116, %bb42 ], [ %v108, %bb43 ]
  %v118 = xor i1 %v96, 1
  br i1 %v118, label %bb50, label %bb45
bb45:
  %v119 = xor i1 %v84, 1
  br i1 %v119, label %bb50, label %bb46
bb46:
  %v120 = mul i64 %v83, %v10
  %v121 = add i64 %v120, %v95
  %v122 = icmp ult i64 %v121, %v27
  br i1 %v122, label %bb47, label %bb74
bb47:
  %v123 = extractvalue { ptr, i64 } %v12, 0
  %v124 = getelementptr inbounds i8, ptr %v123, i64 %v121
  %v125 = load i8, ptr %v124, align 1
  %v126 = icmp eq i8 %v125, 1
  br i1 %v126, label %bb48, label %bb49
bb48:
  %v127 = add i32 %v117, 1
  br label %bb50
bb49:
  br label %bb50
bb50:
  %v128 = phi i32 [ %v117, %bb44 ], [ %v117, %bb45 ], [ %v127, %bb48 ], [ %v117, %bb49 ]
  %v129 = icmp eq i8 %v31, 1
  br i1 %v129, label %bb52, label %bb51
bb51:
  %v130 = icmp eq i32 %v128, 3
  br i1 %v130, label %bb54, label %bb53
bb52:
  %v131 = icmp eq i32 %v128, 2
  br i1 %v131, label %bb54, label %bb51
bb53:
  br label %bb55
bb54:
  br label %bb55
bb55:
  %v132 = phi i8 [ 0, %bb53 ], [ 1, %bb54 ]
  %v133 = extractvalue { ptr, i64 } %v13, 1
  %v134 = icmp ult i64 %v16, %v133
  %v135 = xor i1 %v134, 1
  br i1 %v135, label %bb61, label %bb60
bb56:
  %v136 = extractvalue { i8, ptr } %v142, 1
  store i8 %v132, ptr %v136, align 1
  br label %bb58
bb57:
  br label %bb58
bb58:
  br label %bb59
bb59:
  ret void
bb60:
  %v137 = extractvalue { ptr, i64 } %v13, 0
  %v138 = getelementptr inbounds i8, ptr %v137, i64 %v16
  %v139 = insertvalue { i8, ptr } undef, i8 1, 0
  %v140 = insertvalue { i8, ptr } %v139, ptr %v138, 1
  br label %bb62
bb61:
  %v141 = insertvalue { i8, ptr } undef, i8 0, 0
  br label %bb62
bb62:
  %v142 = phi { i8, ptr } [ %v140, %bb60 ], [ %v141, %bb61 ]
  %v143 = extractvalue { i8, ptr } %v142, 0
  %v144 = zext i8 %v143 to i64
  %v145 = icmp eq i64 %v144, 1
  br i1 %v145, label %bb56, label %bb63
bb63:
  %v146 = icmp eq i64 %v144, 0
  br i1 %v146, label %bb57, label %bb64
bb64:
  unreachable
bb65:
  unreachable
bb66:
  unreachable
bb67:
  unreachable
bb68:
  unreachable
bb69:
  unreachable
bb70:
  unreachable
bb71:
  unreachable
bb72:
  unreachable
bb73:
  unreachable
bb74:
  unreachable
}

declare i32 @llvm.nvvm.read.ptx.sreg.tid.x()
declare i32 @llvm.nvvm.read.ptx.sreg.ctaid.x()
declare i32 @llvm.nvvm.read.ptx.sreg.ntid.x()

define i64 @cuda_device____internal__index_1d(ptr %v0) #0 {
entry:
  br label %bb0
bb0:
  %v1 = phi ptr [ %v0, %entry ]
  %v2 = call i32 @llvm.nvvm.read.ptx.sreg.tid.x() #0
  br label %bb1
bb1:
  %v3 = zext i32 %v2 to i64
  %v4 = call i32 @llvm.nvvm.read.ptx.sreg.ctaid.x() #0
  br label %bb2
bb2:
  %v5 = zext i32 %v4 to i64
  %v6 = call i32 @llvm.nvvm.read.ptx.sreg.ntid.x() #0
  br label %bb3
bb3:
  %v7 = zext i32 %v6 to i64
  %v8 = mul i64 %v5, %v7
  %v9 = add i64 %v8, %v3
  ret i64 %v9
}


attributes #0 = { convergent }
