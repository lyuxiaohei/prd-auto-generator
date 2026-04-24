# 源码分析要点

## 纯HTML/JS项目分析

针对无框架的纯前端项目（如editor.html），按以下方法分析：

### 1. HTML结构分析

**页面区域划分**：
- 识别主要容器元素（class/id语义）
- 提取侧边栏、主内容区、弹窗等区域
- 分析Grid/Flex布局结构

**示例**：
```html
<!-- 分析：四栏布局 -->
<div class="editor-body" style="grid-template-columns: 320px 1fr 180px 340px;">
  <div class="editor-side">左侧面板</div>
  <div class="editor-canvas">画布区域</div>
  <div class="page-layout-container">页面操作区</div>
  <div class="editor-props">属性面板</div>
</div>
```

### 2. JavaScript逻辑分析

**状态变量提取**：
```javascript
// 识别全局状态变量
let currentPageId = '';        // 当前页面ID
let selectedFloorId = '';      // 选中楼层ID
const pageStore = [];          // 页面数据存储
const components = [];         // 组件库配置
```

**函数功能分析**：

| 函数命名模式 | 功能类型 | 示例 |
|--------------|----------|------|
| `render*` | 渲染函数 | renderCanvas, renderPagesPanel |
| `open*Modal` | 弹窗打开 | openGoodsSourceModal |
| `close*Modal` | 弹窗关闭 | closeGoodsSourceModal |
| `handle*` | 事件处理 | handleFloorClick |
| `move*` | 移动操作 | moveFloorUp, moveFloorDown |
| `delete*` | 删除操作 | deleteFloor |
| `duplicate*` | 复制操作 | duplicateFloor |
| `save*` | 保存操作 | saveGoodsSourceConfig |
| `create*` | 创建操作 | createPageFromTemplate |

**事件绑定分析**：
```javascript
// 识别用户交互入口
document.getElementById('btn-add-page').addEventListener('click', function() {
  // 功能：新增页面
});
```

### 3. 弹窗组件分析

**弹窗识别**：
```html
<!-- 识别弹窗结构 -->
<div id="modal-add-page" class="modal">
  <div class="modal-content">
    <div class="modal-header">标题</div>
    <div class="modal-body">内容</div>
    <div class="modal-footer">操作按钮</div>
  </div>
</div>
```

**弹窗功能提取**：

| 弹窗ID | 功能描述 | 触发条件 |
|--------|----------|----------|
| modal-add-page | 新增页面选择 | 点击新建页面按钮 |
| modal-goods-source | 商品数据来源配置 | 点击配置数据来源按钮 |
| modal-image-picker | 素材选择器 | 点击图片上传区域 |

### 4. 组件配置分析

**组件定义提取**：
```javascript
const components = [
  {
    type: 'goods-list',           // 组件类型
    name: '商品列表',              // 组件名称
    desc: '展示多条商品信息...',   // 组件描述
    category: '商品',              // 组件分类
    defaultConfig: {              // 默认配置
      listStyle: 'large-single',
      // ...
    }
  }
];
```

**配置项提取**：
- 识别 `getComponentPropsMarkup()` 等配置面板生成函数
- 提取表单字段：input、select、color-picker等
- 分析配置项与画布渲染的关联

### 5. 业务规则提取

**校验规则提取**：
```javascript
// 从条件判断中提取业务规则
if (tabItems.length >= 5) return;  // 规则：Tab数量上限5个
if (existingTypes.indexOf(type) !== -1) {
  alert('该类型主页面已存在');     // 规则：主页面类型唯一性
}
```

**状态限制提取**：
```javascript
// 按钮禁用条件 → 业务规则
btnLayoutUp.disabled = !selectedFloorId || index === 0;
// 规则：首楼层不可上移
```

## TypeScript项目分析

### 类型定义提取

从 `types/*.ts` 文件中提取：
- 接口定义（interface）→ 输入项说明
- 类型别名（type）→ 字段取值范围
- 枚举定义（enum）→ 下拉选项

### 组件功能提取

从 `pages/*/index.tsx` 文件中提取：
- 状态管理逻辑 → 业务规则
- 事件处理函数 → 交互说明
- 条件判断逻辑 → 校验规则

### Mock数据分析

从 `mock/*.ts` 文件中提取：
- 初始数据结构 → 输出项说明
- 数据生成逻辑 → 字段格式说明