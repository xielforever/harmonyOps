# 运维助手 (HarmonyOps)

运维助手 (HarmonyOps) 是一款专为开发者与运维人员打造的移动端服务器管理工具。基于 HarmonyOS 与原生 ArkUI (ArkTS) 构建，提供纯粹、现代、高对比度的深色模式（"Precision in Darkness"）UI 体验。

## 核心功能模块

* **概览 (Dashboard)**: 实时查看服务器资源使用情况（CPU、内存等）和整体健康度。
* **终端 (Terminal)**: 内置 SSH 终端模拟器，随时随地连接服务器执行命令。
* **告警 (Alerts)**: 接收并管理服务器或应用的异常状态通知。
* **工具 (Scripts)**: 一键执行日常运维脚本（例如重启服务、清理日志等）。

## 项目结构

本应用采用中心化 API 模式获取数据。所有页面与组件均按照独立且可复用的结构划分：

* `entry/src/main/ets/theme/Theme.ets`: 全局深色模式及高对比度样式定义。
* `entry/src/main/ets/components/Card.ets`: 通用卡片组件。
* `entry/src/main/ets/pages/MainPage.ets`: 带有底部 Navigation Tabs 的主页面。
* `entry/src/main/ets/pages/dashboard`: 概览页组件。
* `entry/src/main/ets/pages/terminal`: 终端页组件。
* `entry/src/main/ets/pages/alerts`: 告警页组件。
* `entry/src/main/ets/pages/scripts`: 工具页组件。

## 设计文档与开发计划

详见 [docs/superpowers](./docs/superpowers) 目录下的相关说明：
* 设计文档: `specs/2026-04-08-devops-assistant-design.md`
* 实施计划: `plans/2026-04-08-devops-assistant-plan.md`