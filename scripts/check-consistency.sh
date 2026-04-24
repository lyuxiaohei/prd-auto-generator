#!/bin/bash
# 功能大纲一致性校验脚本

OUTLINE_FILE=$1
PRD_FILE=$2
ERRORS=0

if [ -z "$OUTLINE_FILE" ] || [ -z "$PRD_FILE" ]; then
  echo "用法: ./check-consistency.sh <功能大纲文件> <PRD文件>"
  exit 1
fi

echo "=== 功能大纲一致性校验 ==="
echo "功能大纲: $OUTLINE_FILE"
echo "PRD文档: $PRD_FILE"
echo ""

# 1. 检查PRD章节与大纲模块对应
echo "1. 检查模块对应..."
OUTLINE_MODULES=$(grep -cE "^## [一二三四五六七八九十]+、" "$OUTLINE_FILE" 2>/dev/null || echo "0")
PRD_MODULES=$(grep -cE "^#### 4\.1\.1\.[0-9]+\." "$PRD_FILE" 2>/dev/null || echo "0")

if [ "$PRD_MODULES" -ge "$OUTLINE_MODULES" ]; then
  echo "   [PASS] 模块数量对应: 大纲=$OUTLINE_MODULES, PRD=$PRD_MODULES"
else
  echo "   [FAIL] 模块数量不对应: 大纲=$OUTLINE_MODULES, PRD=$PRD_MODULES"
  ERRORS=$((ERRORS+1))
fi

# 2. 检查业务规则编号对应
echo "2. 检查业务规则编号..."
OUTLINE_RULES=$(grep -oE "RULE-[A-Z]+-[0-9]+" "$OUTLINE_FILE" 2>/dev/null | sort -u | wc -l)
PRD_RULES=$(grep -oE "RULE-[A-Z]+-[0-9]+" "$PRD_FILE" 2>/dev/null | sort -u | wc -l)

if [ "$PRD_RULES" -ge "$OUTLINE_RULES" ]; then
  echo "   [PASS] 业务规则数量对应: 大纲=$OUTLINE_RULES, PRD=$PRD_RULES"
else
  echo "   [FAIL] 业务规则缺失: 大纲=$OUTLINE_RULES, PRD=$PRD_RULES"
  ERRORS=$((ERRORS+1))
fi

# 3. 检查忽略区域未编写
echo "3. 检查忽略区域..."
if grep -q "忽略" "$OUTLINE_FILE"; then
  # 提取忽略区域标题
  IGNORED_TITLES=$(grep -B1 "忽略" "$OUTLINE_FILE" | grep "^##" | sed 's/## //')

  for TITLE in $IGNORED_TITLES; do
    if grep -q "$TITLE" "$PRD_FILE"; then
      echo "   [FAIL] 忽略区域'$TITLE'在PRD中存在内容"
      ERRORS=$((ERRORS+1))
    else
      echo "   [PASS] 忽略区域'$TITLE'已跳过"
    fi
  done
else
  echo "   [INFO] 大纲中无忽略区域"
fi

# 4. 检查关键功能是否覆盖
echo "4. 检查关键功能覆盖..."
# 提取大纲中的关键功能关键词
KEYWORDS=$(grep -oE "([上增新编删修移复][a-zA-Z\u4e00-\u9fa5]+|管理|配置|弹窗)" "$OUTLINE_FILE" | sort -u | head -10)

for KEYWORD in $KEYWORDS; do
  if grep -q "$KEYWORD" "$PRD_FILE"; then
    echo "   [PASS] 关键功能'$KEYWORD'已覆盖"
  else
    echo "   [WARN] 关键功能'$KEYWORD'可能缺失"
  fi
done

# 输出结果
echo ""
echo "=== 校验完成 ==="
if [ $ERRORS -eq 0 ]; then
  echo "✅ 一致性校验通过"
  exit 0
else
  echo "❌ 一致性校验失败，发现 $ERRORS 个错误"
  exit 1
fi