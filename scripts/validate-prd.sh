#!/bin/bash
# PRD文档格式校验脚本

PRD_FILE=$1
ERRORS=0

if [ -z "$PRD_FILE" ]; then
  echo "用法: ./validate-prd.sh <PRD文件路径>"
  exit 1
fi

echo "=== PRD文档格式校验 ==="
echo "文件: $PRD_FILE"
echo ""

# 1. 检查前置章节仅标题
echo "1. 检查前置章节结构..."
if grep -q "^# 1\. 需求背景$" "$PRD_FILE" && \
   grep -q "^# 2\. 需求分析$" "$PRD_FILE" && \
   grep -q "^# 3\. 系统流程图$" "$PRD_FILE"; then
  echo "   [PASS] 前置章节结构正确"
else
  echo "   [FAIL] 前置章节结构错误"
  ERRORS=$((ERRORS+1))
fi

# 2. 检查章节标注清理
echo "2. 检查章节标注..."
if grep -qE "【必须】|【按需】|【仅标题】|【系统标题下无内容】|【模块标题下无内容】" "$PRD_FILE"; then
  echo "   [FAIL] 文档包含章节标注，需要清理"
  ERRORS=$((ERRORS+1))
else
  echo "   [PASS] 章节标注已清理"
fi

# 3. 检查字段标识命名
echo "3. 检查字段标识命名..."
# 检查是否有驼峰命名（字段标识列中出现大写字母）
if grep -qE "\| [a-z]+[A-Z][a-z]+ \|" "$PRD_FILE"; then
  echo "   [FAIL] 字段标识命名不规范（应使用snake_case）"
  ERRORS=$((ERRORS+1))
else
  echo "   [PASS] 字段标识命名规范"
fi

# 4. 检查标题编号格式
echo "4. 检查标题编号格式..."
if grep -qE "^#{1,5} [一二三四五六七八九十]+" "$PRD_FILE"; then
  echo "   [FAIL] 标题使用中文数字编号（应使用阿拉伯数字）"
  ERRORS=$((ERRORS+1))
else
  echo "   [PASS] 标题编号格式正确"
fi

# 5. 检查Mermaid流程图
echo "5. 检查流程图语法..."
FLOWCHART_COUNT=$(grep -c "^\`\`\`mermaid" "$PRD_FILE" 2>/dev/null || echo "0")
if [ "$FLOWCHART_COUNT" -gt 0 ]; then
  echo "   [PASS] 流程图数量: $FLOWCHART_COUNT"

  # 检查流程图是否有开始结束节点
  BEGIN_COUNT=$(grep -c "\[开始\]" "$PRD_FILE" 2>/dev/null || echo "0")
  END_COUNT=$(grep -c "\[结束\]" "$PRD_FILE" 2>/dev/null || echo "0")
  if [ "$BEGIN_COUNT" -ge "$FLOWCHART_COUNT" ] && [ "$END_COUNT" -ge "$FLOWCHART_COUNT" ]; then
    echo "   [PASS] 流程图包含开始/结束节点"
  else
    echo "   [WARN] 部分流程图可能缺少开始/结束节点"
  fi
else
  echo "   [WARN] 未检测到流程图，请确认是否需要"
fi

# 6. 检查业务规则编号格式
echo "6. 检查业务规则编号..."
RULE_COUNT=$(grep -cE "RULE-[A-Z]+-[0-9]+" "$PRD_FILE" 2>/dev/null || echo "0")
if [ "$RULE_COUNT" -gt 0 ]; then
  echo "   [PASS] 业务规则数量: $RULE_COUNT"
else
  echo "   [WARN] 未检测到业务规则编号"
fi

# 输出结果
echo ""
echo "=== 校验完成 ==="
if [ $ERRORS -eq 0 ]; then
  echo "✅ 校验通过，无错误"
  exit 0
else
  echo "❌ 校验失败，发现 $ERRORS 个错误"
  exit 1
fi