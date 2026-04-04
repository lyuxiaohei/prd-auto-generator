# prd-auto-generator

> 基于项目功能大纲、源码和需求文档规范，自动生成完整的产品需求文档(PRD)。支持Mermaid流程图、业务规则定义、一致性检查等功能。

## 安装方式

### 方式1：手动安装

```bash
git clone https://github.com/lyuxiaohei/prd-auto-generator.git ~/.claude/skills/prd-auto-generator
```

### 方式2：直接复制

将 `prd-auto-generator` 文件夹复制到 `~/.claude/skills/` 目录。

## 触发场景

- "基于功能大纲生成PRD文档"
- "为新项目创建PRD"
- "生成产品需求文档"
- "根据源码生成需求文档"

## 输入参数

| 参数名称 | 参数说明 | 示例值 |
|----------|----------|--------|
| 功能大纲路径 | 项目功能结构大纲文件路径 | feature-outline.md |
| 规范文档路径 | 需求文档编写规范模板路径 | references/prd-template-specification.md |
| 源码目录 | 项目源码根目录 | src/ |
| 输出路径 | 生成的PRD文档保存路径 | PRD-{项目名}-V1.0.md |

## 使用示例

```
基于以下参考资料生成PRD文档：
1. docs/功能大纲.md - 项目功能结构大纲
2. 当前项目源码

输出路径：docs/PRD-商城运营后台-V1.0.md
```

## 功能特点

- 自动解析功能大纲，识别核心模块层级
- 从源码提取类型定义、业务逻辑
- 生成标准化Mermaid流程图
- 业务规则与流程图分支一一对应
- 一致性检查：确保不超出大纲范围

## 参考文档

| 文件名 | 用途说明 |
|--------|----------|
| `prd-template-specification.md` | PRD文档章节结构规范模板 |
| `example-prd-output.md` | 完整PRD生成效果示例 |
| `example-feature-outline.md` | 功能大纲格式示例 |

## 许可证

MIT License