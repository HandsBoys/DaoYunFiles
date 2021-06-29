/*
 Navicat Premium Data Transfer

 Source Server         : DaoYunSQL_Docker
 Source Server Type    : MySQL
 Source Server Version : 80024
 Source Host           : localhost:3306
 Source Schema         : daoyun

 Target Server Type    : MySQL
 Target Server Version : 80024
 File Encoding         : 65001

 Date: 28/06/2021 18:08:12
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_checkin
-- ----------------------------
DROP TABLE IF EXISTS `sys_checkin`;
CREATE TABLE `sys_checkin`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` int NULL DEFAULT NULL COMMENT '签到类型',
  `course_id` bigint UNSIGNED NOT NULL COMMENT '发起签到的班课id',
  `teacher_id` bigint UNSIGNED NOT NULL COMMENT '发起者id',
  `lng` double NULL DEFAULT NULL COMMENT '经度',
  `lat` double NULL DEFAULT NULL COMMENT '纬度',
  `start_time` datetime NOT NULL COMMENT '发起时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `is_finish` tinyint(1) NOT NULL COMMENT '签到是否结束(0:未结束；1:已结束)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `teacher_id`(`teacher_id`) USING BTREE,
  INDEX `course_id`(`course_id`) USING BTREE,
  CONSTRAINT `sys_checkin_ibfk_3` FOREIGN KEY (`course_id`) REFERENCES `sys_course` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '签到任务表\r\n' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_checkin
-- ----------------------------

-- ----------------------------
-- Table structure for sys_checkin_student
-- ----------------------------
DROP TABLE IF EXISTS `sys_checkin_student`;
CREATE TABLE `sys_checkin_student`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '签到信息id',
  `checkin_id` bigint UNSIGNED NOT NULL COMMENT '发起的签到id',
  `student_id` bigint UNSIGNED NOT NULL COMMENT '签到者id',
  `lng` double NULL DEFAULT NULL COMMENT '经度',
  `lat` double NULL DEFAULT NULL COMMENT '纬度',
  `checkin_time` datetime NULL DEFAULT NULL COMMENT '签到时间',
  `is_finish` tinyint(1) NULL DEFAULT NULL COMMENT '是否签到（0：未签到；1：已签到）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `start_checkin_id`(`checkin_id`) USING BTREE,
  INDEX `student_id`(`student_id`) USING BTREE,
  CONSTRAINT `sys_checkin_student_ibfk_1` FOREIGN KEY (`checkin_id`) REFERENCES `sys_checkin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sys_checkin_student_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `sys_course_students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '签到记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_checkin_student
-- ----------------------------

-- ----------------------------
-- Table structure for sys_class
-- ----------------------------
DROP TABLE IF EXISTS `sys_class`;
CREATE TABLE `sys_class`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '班级id',
  `class_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '班级名称',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '班级状态，是否停用（0正常 1停用）',
  `create_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `last_update_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '更新者',
  `last_update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` tinyint(1) NULL DEFAULT 0 COMMENT '删除标志（0代表存在 1代表删除）',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `create_by`(`create_by`) USING BTREE,
  INDEX `last_update_by`(`last_update_by`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 83 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '班级表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_class
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `create_by`(`create_by`) USING BTREE,
  INDEX `update_by`(`update_by`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '默认密码', 'password', '123456', 'Y', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_config` VALUES (25, '签到经验值', 'experience', '2', 'N', 46, '2021-06-08 16:10:54', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_course
-- ----------------------------
DROP TABLE IF EXISTS `sys_course`;
CREATE TABLE `sys_course`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '课程id',
  `course_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '课程名称',
  `term` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '学期',
  `teacher_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '课程教师',
  `class_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '班级id',
  `enable_join` tinyint(1) NULL DEFAULT NULL COMMENT '能否加入（0：不可以加入，1：可以加入）',
  `finish` tinyint(1) NULL DEFAULT NULL COMMENT '班课是否结束（0：未结束，1：结束）',
  `create_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `last_update_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '更新者',
  `last_update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `teacher_id`(`teacher_id`) USING BTREE,
  INDEX `class_id`(`class_id`) USING BTREE,
  INDEX `create_by`(`create_by`) USING BTREE,
  CONSTRAINT `sys_course_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `sys_course_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `sys_class` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '班课表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_course
-- ----------------------------

-- ----------------------------
-- Table structure for sys_course_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_course_dept`;
CREATE TABLE `sys_course_dept`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `course_id` bigint UNSIGNED NOT NULL COMMENT '班课id',
  `dept_id` bigint UNSIGNED NOT NULL COMMENT '机构id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `course_id`(`course_id`) USING BTREE,
  INDEX `dept_id`(`dept_id`) USING BTREE,
  CONSTRAINT `sys_course_dept_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `sys_course` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sys_course_dept_ibfk_2` FOREIGN KEY (`dept_id`) REFERENCES `sys_dept` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '班课机构关联表\r\n' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_course_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_course_students
-- ----------------------------
DROP TABLE IF EXISTS `sys_course_students`;
CREATE TABLE `sys_course_students`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `course_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '班课id',
  `student_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '学生id',
  `score` bigint NULL DEFAULT 0 COMMENT '分数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_id`(`course_id`) USING BTREE,
  INDEX `sys_class_students_ibfk_2`(`student_id`) USING BTREE,
  INDEX `student_id`(`student_id`, `course_id`) USING BTREE,
  CONSTRAINT `sys_course_students_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `sys_course` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sys_course_students_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '班级学生表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_course_students
-- ----------------------------

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `dept_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `dept_level` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门级别（U:学校；C:学院；S:专业/系）',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '部门状态（0正常 1停用）',
  `del_flag` tinyint(1) NULL DEFAULT 0 COMMENT '删除标志（0代表存在 1代表删除）',
  `create_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `create_by`(`create_by`) USING BTREE,
  INDEX `update_by`(`update_by`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字典标签',
  `dict_value` int NULL DEFAULT NULL COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字典类型',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '状态（0正常 1停用）',
  `create_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `last_update_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '更新人',
  `last_update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `is_default` tinyint(1) NULL DEFAULT 0 COMMENT '是否为默认值（0：不是默认；1：默认）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `type_id`(`dict_value`) USING BTREE,
  INDEX `dict_type`(`dict_type`) USING BTREE,
  INDEX `create_by`(`create_by`) USING BTREE,
  INDEX `last_update_by`(`last_update_by`) USING BTREE,
  CONSTRAINT `sys_dict_data_ibfk_1` FOREIGN KEY (`dict_type`) REFERENCES `sys_dict_type` (`dict_type`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 331 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (9, 2, '男', 0, 'sys_user_sex', 0, NULL, NULL, 46, '2021-06-08 17:01:10', NULL, 1);
INSERT INTO `sys_dict_data` VALUES (10, 0, '女', 1, 'sys_user_sex', 0, NULL, NULL, 46, '2021-06-08 17:01:10', NULL, 0);
INSERT INTO `sys_dict_data` VALUES (11, 1, '未知', 2, 'sys_user_sex', 0, NULL, NULL, 46, '2021-06-08 17:01:10', NULL, 0);
INSERT INTO `sys_dict_data` VALUES (14, 0, '一键签到', 0, 'sys_checkin_type', 0, NULL, NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_dict_data` VALUES (15, 1, '限时签到', 1, 'sys_checkin_type', 0, NULL, NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_dict_data` VALUES (16, 0, '小学', 0, 'sys_education', 0, NULL, NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_dict_data` VALUES (17, 1, '初中', 1, 'sys_education', 0, NULL, NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_dict_data` VALUES (18, 2, '高中', 2, 'sys_education', 0, NULL, NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_dict_data` VALUES (19, 3, '本科', 3, 'sys_education', 0, NULL, NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_dict_data` VALUES (20, 4, '硕士', 4, 'sys_education', 0, NULL, NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_dict_data` VALUES (21, 5, '博士', 5, 'sys_education', 0, NULL, NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_dict_data` VALUES (150, 0, '2021-2022-1', 202120221, 'term', 0, 46, '2021-06-15 11:40:41', NULL, NULL, NULL, 1);
INSERT INTO `sys_dict_data` VALUES (151, 1, '2021-2022-2', 202120222, 'term', 0, 46, '2021-06-15 11:40:41', NULL, NULL, NULL, 0);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字典类型',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '状态（0正常 1停用）',
  `create_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `last_update_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '更新者',
  `last_update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `dict_type`(`dict_type`) USING BTREE,
  INDEX `create_by`(`create_by`) USING BTREE,
  INDEX `last_update_by`(`last_update_by`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 85 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典类型表\r\n\r\n' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (15, '性别', 'sys_user_sex', 0, NULL, NULL, 46, '2021-06-08 17:01:09', NULL);
INSERT INTO `sys_dict_type` VALUES (16, '签到类型', 'sys_checkin_type', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (18, '学历', 'sys_education', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (75, '学期', 'term', 0, 46, '2021-06-15 11:40:41', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `id` bigint NOT NULL COMMENT '访问日志id',
  `user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登录时的ip地址',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  `login_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作系统',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_name`(`user_name`) USING BTREE,
  CONSTRAINT `sys_logininfor_ibfk_1` FOREIGN KEY (`user_name`) REFERENCES `sys_user` (`user_name`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '登录日志表\r\n' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `is_frame` tinyint(1) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` tinyint(1) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` tinyint(1) NULL DEFAULT 1 COMMENT '菜单状态（0隐藏 1显示）',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `last_update_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '更新者',
  `last_update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `create_by`(`create_by`) USING BTREE,
  INDEX `last_update_by`(`last_update_by`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1112 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统首页', 0, 1, 'Welcome', NULL, 1, 0, 'C', 1, 0, '', 'system', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2, '系统管理', 0, 1, '', NULL, 1, 0, 'M', 1, 0, NULL, 'example', NULL, NULL, NULL, NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 2, 1, 'UserManage', 'system/user/index', 1, 0, 'C', 1, 0, 'system:user:list', 'user', NULL, '2021-03-23 19:55:35', NULL, NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 2, 2, 'RoleManage', 'system/role/index', 1, 0, 'C', 1, 0, 'system:role:list', 'peoples', NULL, '2021-03-23 19:55:35', NULL, '2021-06-27 18:53:09', '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 2, 3, 'MenuManage', 'system/menu/index', 1, 0, 'C', 1, 0, 'system:menu:list', 'tree-table', NULL, '2021-03-23 19:55:35', NULL, '2021-06-27 18:53:05', '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 2, 6, 'DictManage', 'system/dict/index', 1, 0, 'C', 1, 0, 'system:dict:list', 'dict', NULL, '2021-03-23 19:55:35', NULL, NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 2, 7, 'ParameterManage', 'system/config/index', 1, 0, 'C', 1, 0, 'system:config:list', 'edit', NULL, '2021-03-23 19:55:35', NULL, NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '班课管理', 2, 8, 'CourseManage', 'system/course/index', 1, 0, 'C', 1, 0, 'system:course:list', 'message', NULL, NULL, NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (108, '机构管理', 2, 8, 'InstitutionManage', NULL, 1, 0, 'C', 1, 0, 'system:dept:list', 'skill', NULL, NULL, NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户查询', 100, 1, '', '', 1, 0, 'F', 1, 0, 'system:user:query', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户新增', 100, 2, '', '', 1, 0, 'F', 1, 0, 'system:user:add', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户修改', 100, 3, '', '', 1, 0, 'F', 1, 0, 'system:user:edit', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户删除', 100, 4, '', '', 1, 0, 'F', 1, 0, 'system:user:remove', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导出', 100, 5, '', '', 1, 0, 'F', 1, 0, 'system:user:export', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '用户导入', 100, 6, '', '', 1, 0, 'F', 1, 0, 'system:user:import', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '重置密码', 100, 7, '', '', 1, 0, 'F', 1, 0, 'system:user:resetPwd', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色新增', 101, 2, '', '', 1, 0, 'F', 1, 0, 'system:role:add', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色修改', 101, 3, '', '', 1, 0, 'F', 1, 0, 'system:role:edit', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色删除', 101, 4, '', '', 1, 0, 'F', 1, 0, 'system:role:remove', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '角色导出', 101, 5, '', '', 1, 0, 'F', 1, 0, 'system:role:export', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单查询', 102, 1, '', '', 1, 0, 'F', 1, 0, 'system:menu:query', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单新增', 102, 2, '', '', 1, 0, 'F', 1, 0, 'system:menu:add', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单修改', 102, 3, '', '', 1, 0, 'F', 1, 0, 'system:menu:edit', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '菜单删除', 102, 4, '', '', 1, 0, 'F', 1, 0, 'system:menu:remove', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典查询', 105, 1, '#', '', 1, 0, 'F', 1, 0, 'system:dict:query', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典新增', 105, 2, '#', '', 1, 0, 'F', 1, 0, 'system:dict:add', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典修改', 105, 3, '#', '', 1, 0, 'F', 1, 0, 'system:dict:edit', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典删除', 105, 4, '#', '', 1, 0, 'F', 1, 0, 'system:dict:remove', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '字典导出', 105, 5, '#', '', 1, 0, 'F', 1, 0, 'system:dict:export', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数查询', 106, 1, '#', '', 1, 0, 'F', 1, 0, 'system:config:query', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数新增', 106, 2, '#', '', 1, 0, 'F', 1, 0, 'system:config:add', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数修改', 106, 3, '#', '', 1, 0, 'F', 1, 0, 'system:config:edit', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数删除', 106, 4, '#', '', 1, 0, 'F', 1, 0, 'system:config:remove', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '参数导出', 106, 5, '#', '', 1, 0, 'F', 1, 0, 'system:config:export', '#', NULL, '2021-03-23 19:55:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1070, '班课新增', 107, 1, '#', NULL, 1, 0, 'F', 1, 0, 'system:course:add', '#', NULL, NULL, NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1071, '班课修改', 107, 2, '#', NULL, 1, 0, 'F', 1, 0, 'system:course:edit', '#', NULL, NULL, NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1072, '班课删除', 107, 3, '#', NULL, 1, 0, 'F', 1, 0, 'system:course:remove', '#', NULL, NULL, NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1073, '班课查询', 107, 4, '#', NULL, 1, 0, 'F', 1, 0, 'system:course:query', '#', NULL, NULL, NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1074, '加入班课', 107, 5, '#', NULL, 1, 0, 'F', 1, 0, 'system:course:join', '#', NULL, NULL, NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1075, '退出班课', 107, 5, '#', NULL, 1, 0, 'F', 1, 0, 'system:course:quit', '#', NULL, NULL, NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1076, '班课列表', 107, 1, '', NULL, 1, 0, 'F', 1, 0, 'system:course:list', '#', NULL, '2021-06-27 18:44:55', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1081, '机构查询', 108, 1, '#', NULL, 1, 0, 'F', 1, 0, 'system:dept:query', '#', NULL, NULL, NULL, '2021-06-27 18:55:53', '');
INSERT INTO `sys_menu` VALUES (1082, '机构新增', 108, 2, '#', NULL, 1, 0, 'F', 1, 0, 'system:dept:add', '#', NULL, NULL, NULL, '2021-06-27 18:55:58', '');
INSERT INTO `sys_menu` VALUES (1083, '机构修改', 108, 3, '#', NULL, 1, 0, 'F', 1, 0, 'system:dept:edit', '#', NULL, NULL, NULL, '2021-06-27 18:56:02', '');
INSERT INTO `sys_menu` VALUES (1084, '机构删除', 108, 4, '#', NULL, 1, 0, 'F', 1, 0, 'system:dept:remove', '#', NULL, NULL, NULL, '2021-06-27 18:56:06', '');
INSERT INTO `sys_menu` VALUES (1085, '机构列表', 108, 1, '', NULL, 1, 0, 'F', 1, 0, 'system:dept:list', '#', NULL, '2021-06-27 18:53:57', NULL, '2021-06-27 18:56:10', '');
INSERT INTO `sys_menu` VALUES (1107, '用户列表', 100, 8, '', NULL, 1, 0, 'F', 1, 0, 'system:user:list', '#', NULL, '2021-06-27 18:57:22', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1108, '角色列表', 101, 5, '', NULL, 1, 0, 'F', 1, 0, 'system:role:list', '#', NULL, '2021-06-27 18:57:48', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1109, '菜单列表', 102, 5, '', NULL, 1, 0, 'F', 1, 0, 'system:menu:list', '#', NULL, '2021-06-27 18:58:14', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1110, '字典列表', 105, 6, '', NULL, 1, 0, 'F', 1, 0, 'system:dict:list', '#', NULL, '2021-06-27 18:58:35', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (1111, '参数列表', 106, 6, '', NULL, 1, 0, 'F', 1, 0, 'system:config:list', '#', NULL, '2021-06-27 18:59:03', NULL, '2021-06-27 18:59:08', '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` int NULL DEFAULT 1 COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本班课数据权限 ）',
  `status` tinyint(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
  `create_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `last_update_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '更新者',
  `last_update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` tinyint(1) NULL DEFAULT 0 COMMENT '删除标志（0代表存在 2代表删除）',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `create_by`(`create_by`) USING BTREE,
  INDEX `last_update_by`(`last_update_by`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '管理员', 'ROLE_admin', 1, 1, 0, NULL, NULL, NULL, NULL, 0, NULL);
INSERT INTO `sys_role` VALUES (2, '教师', 'ROLE_teacher', 2, 2, 0, NULL, NULL, NULL, NULL, 0, NULL);
INSERT INTO `sys_role` VALUES (10, '学生', 'ROLE_student', 0, 1, 0, NULL, '2021-06-23 14:34:43', NULL, NULL, 0, NULL);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` bigint UNSIGNED NOT NULL COMMENT '角色id',
  `menu_id` bigint UNSIGNED NOT NULL COMMENT '菜单id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `menu_id`(`menu_id`) USING BTREE,
  INDEX `role_id`(`role_id`) USING BTREE,
  CONSTRAINT `sys_role_menu_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sys_role_menu_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 967 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (887, 1, 1);
INSERT INTO `sys_role_menu` VALUES (888, 1, 2);
INSERT INTO `sys_role_menu` VALUES (889, 1, 100);
INSERT INTO `sys_role_menu` VALUES (890, 1, 1001);
INSERT INTO `sys_role_menu` VALUES (891, 1, 1002);
INSERT INTO `sys_role_menu` VALUES (892, 1, 1003);
INSERT INTO `sys_role_menu` VALUES (893, 1, 1004);
INSERT INTO `sys_role_menu` VALUES (894, 1, 1005);
INSERT INTO `sys_role_menu` VALUES (895, 1, 1006);
INSERT INTO `sys_role_menu` VALUES (896, 1, 1007);
INSERT INTO `sys_role_menu` VALUES (897, 1, 1107);
INSERT INTO `sys_role_menu` VALUES (898, 1, 101);
INSERT INTO `sys_role_menu` VALUES (899, 1, 1009);
INSERT INTO `sys_role_menu` VALUES (900, 1, 1010);
INSERT INTO `sys_role_menu` VALUES (901, 1, 1011);
INSERT INTO `sys_role_menu` VALUES (902, 1, 1012);
INSERT INTO `sys_role_menu` VALUES (903, 1, 1108);
INSERT INTO `sys_role_menu` VALUES (904, 1, 102);
INSERT INTO `sys_role_menu` VALUES (905, 1, 1013);
INSERT INTO `sys_role_menu` VALUES (906, 1, 1014);
INSERT INTO `sys_role_menu` VALUES (907, 1, 1015);
INSERT INTO `sys_role_menu` VALUES (908, 1, 1016);
INSERT INTO `sys_role_menu` VALUES (909, 1, 1109);
INSERT INTO `sys_role_menu` VALUES (910, 1, 105);
INSERT INTO `sys_role_menu` VALUES (911, 1, 1026);
INSERT INTO `sys_role_menu` VALUES (912, 1, 1027);
INSERT INTO `sys_role_menu` VALUES (913, 1, 1028);
INSERT INTO `sys_role_menu` VALUES (914, 1, 1029);
INSERT INTO `sys_role_menu` VALUES (915, 1, 1030);
INSERT INTO `sys_role_menu` VALUES (916, 1, 1110);
INSERT INTO `sys_role_menu` VALUES (917, 1, 106);
INSERT INTO `sys_role_menu` VALUES (918, 1, 1031);
INSERT INTO `sys_role_menu` VALUES (919, 1, 1032);
INSERT INTO `sys_role_menu` VALUES (920, 1, 1033);
INSERT INTO `sys_role_menu` VALUES (921, 1, 1034);
INSERT INTO `sys_role_menu` VALUES (922, 1, 1035);
INSERT INTO `sys_role_menu` VALUES (923, 1, 1111);
INSERT INTO `sys_role_menu` VALUES (924, 1, 107);
INSERT INTO `sys_role_menu` VALUES (925, 1, 1070);
INSERT INTO `sys_role_menu` VALUES (926, 1, 1071);
INSERT INTO `sys_role_menu` VALUES (927, 1, 1072);
INSERT INTO `sys_role_menu` VALUES (928, 1, 1073);
INSERT INTO `sys_role_menu` VALUES (929, 1, 1074);
INSERT INTO `sys_role_menu` VALUES (930, 1, 1075);
INSERT INTO `sys_role_menu` VALUES (931, 1, 1076);
INSERT INTO `sys_role_menu` VALUES (932, 1, 108);
INSERT INTO `sys_role_menu` VALUES (933, 1, 1081);
INSERT INTO `sys_role_menu` VALUES (934, 1, 1082);
INSERT INTO `sys_role_menu` VALUES (935, 1, 1083);
INSERT INTO `sys_role_menu` VALUES (936, 1, 1084);
INSERT INTO `sys_role_menu` VALUES (937, 1, 1085);
INSERT INTO `sys_role_menu` VALUES (938, 2, 1);
INSERT INTO `sys_role_menu` VALUES (939, 2, 102);
INSERT INTO `sys_role_menu` VALUES (940, 2, 1013);
INSERT INTO `sys_role_menu` VALUES (941, 2, 1014);
INSERT INTO `sys_role_menu` VALUES (942, 2, 1015);
INSERT INTO `sys_role_menu` VALUES (943, 2, 1016);
INSERT INTO `sys_role_menu` VALUES (944, 2, 1109);
INSERT INTO `sys_role_menu` VALUES (945, 2, 107);
INSERT INTO `sys_role_menu` VALUES (946, 2, 1070);
INSERT INTO `sys_role_menu` VALUES (947, 2, 1071);
INSERT INTO `sys_role_menu` VALUES (948, 2, 1072);
INSERT INTO `sys_role_menu` VALUES (949, 2, 1073);
INSERT INTO `sys_role_menu` VALUES (950, 2, 1074);
INSERT INTO `sys_role_menu` VALUES (951, 2, 1075);
INSERT INTO `sys_role_menu` VALUES (952, 2, 1076);
INSERT INTO `sys_role_menu` VALUES (953, 2, 108);
INSERT INTO `sys_role_menu` VALUES (954, 2, 1081);
INSERT INTO `sys_role_menu` VALUES (955, 2, 1082);
INSERT INTO `sys_role_menu` VALUES (956, 2, 1083);
INSERT INTO `sys_role_menu` VALUES (957, 2, 1084);
INSERT INTO `sys_role_menu` VALUES (958, 2, 1085);
INSERT INTO `sys_role_menu` VALUES (959, 10, 1);
INSERT INTO `sys_role_menu` VALUES (960, 10, 1073);
INSERT INTO `sys_role_menu` VALUES (961, 10, 1074);
INSERT INTO `sys_role_menu` VALUES (962, 10, 1075);
INSERT INTO `sys_role_menu` VALUES (963, 10, 1076);
INSERT INTO `sys_role_menu` VALUES (964, 10, 1081);
INSERT INTO `sys_role_menu` VALUES (965, 10, 1082);
INSERT INTO `sys_role_menu` VALUES (966, 10, 1085);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '昵称',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '邮箱',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '密码',
  `avatar` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '头像',
  `identity_number` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '学/工号',
  `sex` int NULL DEFAULT 2 COMMENT '性别（0男 1女 2未知）',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '帐号状态（0正常 1停用）',
  `create_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `last_update_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '更新者',
  `last_update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_name`(`user_name`) USING BTREE,
  INDEX `create_by`(`create_by`) USING BTREE,
  INDEX `last_update_by`(`last_update_by`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息表\r\n' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', 'admin', '', '15900000001', '$2a$10$z7qh3PyN7HLb/A7S5jw2AOkTgVbXfc9GXbYSQtvY6RqlMneiFBPum', '', NULL, 2, 0, 1, '2021-06-25 23:22:57', NULL, NULL, '0', NULL);
INSERT INTO `sys_user` VALUES (2, 'teacher1', 'teacher1', '', '15900000002', '$2a$10$ieumhfQwXvr57TnTre44aehVAAeVQny4qzPDqXPloKuCaDHAPOfvS', '', NULL, 0, 0, 1, '2021-06-23 14:34:11', NULL, NULL, '0', NULL);
INSERT INTO `sys_user` VALUES (3, 'student1', 'student1', '', '15900000003', '$2a$10$H9XPLNZ7n35vA5TgqOkp9emJ/QjwkZE8OPsiazg5zEj4NKf9o4jeq', '', NULL, 0, 0, 1, '2021-06-23 14:35:46', NULL, NULL, '0', NULL);
INSERT INTO `sys_user` VALUES (4, 'student2', 'student2', '', '15900000004', '$2a$10$bm1LPTd7THGcA96zfh2yeeg4ni.abSWLIfPQEwoS0RCcN83v3V/ti', '', NULL, 2, 0, 1, '2021-06-23 14:36:12', NULL, NULL, '0', NULL);

-- ----------------------------
-- Table structure for sys_user_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_dept`;
CREATE TABLE `sys_user_dept`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户id',
  `dept_id` bigint UNSIGNED NOT NULL COMMENT '部门id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `dept_id`(`dept_id`) USING BTREE,
  CONSTRAINT `sys_user_dept_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sys_user_dept_ibfk_2` FOREIGN KEY (`dept_id`) REFERENCES `sys_dept` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户id',
  `role_id` bigint UNSIGNED NOT NULL COMMENT '角色id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `role_id`(`role_id`) USING BTREE,
  CONSTRAINT `sys_user_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sys_user_role_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 98 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (79, 2, 2);
INSERT INTO `sys_user_role` VALUES (80, 3, 10);
INSERT INTO `sys_user_role` VALUES (81, 4, 10);
INSERT INTO `sys_user_role` VALUES (96, 0, 1);

SET FOREIGN_KEY_CHECKS = 1;
