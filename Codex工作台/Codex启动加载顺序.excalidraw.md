---
excalidraw-plugin: parsed
tags: ["codex", "agent", "skill", "tooling", "cli"]
  - codex
title: "Codex启动加载顺序"
source: "Codex工作台/Codex启动加载顺序.excalidraw.md"
author: "Allen"
published: 
created: 2026-05-07
description: "==⚠  Switch to EXCALIDRAW VIEW in Obsidian.  ⚠=="
type: "diagram"
status: "processed"
---
==⚠  Switch to EXCALIDRAW VIEW in Obsidian.  ⚠==

# Text Elements

Codex 启动加载顺序 ^title

启动主链路 ^lane1

AGENTS.md 层级 ^lane2

Skill 加载与触发 ^lane3

Tool / MCP 注入 ^lane4

内置默认值 ^n1

~/.codex/config.toml ^n2

profile ^n3

CLI 参数 ^n4

-c 覆盖 ^n5

最终运行配置 ^n6

working root ^n7

~/.codex/AGENTS.md ^a1

/repo/AGENTS.md ^a2

/repo/service/AGENTS.md ^a3

当前目录 AGENTS.md ^a4

更近目录更具体 ^a5

启动时发现 Skill 清单 ^s1

只读名称 / 描述 / 路径 ^s2

用户请求触发匹配 ^s3

按需读取 SKILL.md ^s4

执行 Skill 工作流 ^s5

config.toml 中 MCP 定义 ^m1

启动 / 连接 MCP Server ^m2

枚举 tools / resources ^m3

内置 tools + 插件 tools ^m4

任务中按需调用 ^m5

同名规则：personal skill 优先于 superpowers skill ^note1

冲突规则：system/developer > config/CLI > AGENTS > skill > user request ^note2

%%
# Drawing
```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://github.com/zsviczian/obsidian-excalidraw-plugin",
  "elements": [
    {"id":"title","type":"text","x":360,"y":20,"width":420,"height":45,"angle":0,"strokeColor":"#1f2937","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":101,"version":1,"versionNonce":1011,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"Codex 启动加载顺序","fontSize":36,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"Codex 启动加载顺序","lineHeight":1.25,"baseline":35},

    {"id":"lane1-bg","type":"rectangle","x":40,"y":100,"width":1080,"height":170,"angle":0,"strokeColor":"#2563eb","backgroundColor":"#dbeafe","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":102,"version":1,"versionNonce":1021,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"lane1","type":"text","x":60,"y":118,"width":140,"height":30,"angle":0,"strokeColor":"#1e40af","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":103,"version":1,"versionNonce":1031,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"启动主链路","fontSize":24,"fontFamily":1,"textAlign":"left","verticalAlign":"top","containerId":null,"originalText":"启动主链路","lineHeight":1.25,"baseline":23},

    {"id":"r1","type":"rectangle","x":80,"y":170,"width":130,"height":55,"angle":0,"strokeColor":"#1e40af","backgroundColor":"#eff6ff","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":104,"version":1,"versionNonce":1041,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"n1","type":"text","x":93,"y":184,"width":104,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":105,"version":1,"versionNonce":1051,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"内置默认值","fontSize":20,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"内置默认值","lineHeight":1.25,"baseline":20},
    {"id":"r2","type":"rectangle","x":250,"y":170,"width":190,"height":55,"angle":0,"strokeColor":"#1e40af","backgroundColor":"#eff6ff","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":106,"version":1,"versionNonce":1061,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"n2","type":"text","x":260,"y":184,"width":170,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":107,"version":1,"versionNonce":1071,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"~/.codex/config.toml","fontSize":18,"fontFamily":3,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"~/.codex/config.toml","lineHeight":1.25,"baseline":18},
    {"id":"r3","type":"rectangle","x":480,"y":170,"width":110,"height":55,"angle":0,"strokeColor":"#1e40af","backgroundColor":"#eff6ff","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":108,"version":1,"versionNonce":1081,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"n3","type":"text","x":506,"y":184,"width":58,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":109,"version":1,"versionNonce":1091,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"profile","fontSize":20,"fontFamily":3,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"profile","lineHeight":1.25,"baseline":20},
    {"id":"r4","type":"rectangle","x":630,"y":170,"width":120,"height":55,"angle":0,"strokeColor":"#1e40af","backgroundColor":"#eff6ff","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":110,"version":1,"versionNonce":1101,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"n4","type":"text","x":653,"y":184,"width":74,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":111,"version":1,"versionNonce":1111,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"CLI 参数","fontSize":20,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"CLI 参数","lineHeight":1.25,"baseline":20},
    {"id":"r5","type":"rectangle","x":790,"y":170,"width":110,"height":55,"angle":0,"strokeColor":"#1e40af","backgroundColor":"#eff6ff","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":112,"version":1,"versionNonce":1121,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"n5","type":"text","x":812,"y":184,"width":66,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":113,"version":1,"versionNonce":1131,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"-c 覆盖","fontSize":20,"fontFamily":3,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"-c 覆盖","lineHeight":1.25,"baseline":20},
    {"id":"r6","type":"rectangle","x":940,"y":170,"width":140,"height":55,"angle":0,"strokeColor":"#1e40af","backgroundColor":"#bfdbfe","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":114,"version":1,"versionNonce":1141,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"n6","type":"text","x":955,"y":184,"width":110,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":115,"version":1,"versionNonce":1151,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"最终运行配置","fontSize":20,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"最终运行配置","lineHeight":1.25,"baseline":20},

    {"id":"lane2-bg","type":"rectangle","x":40,"y":300,"width":1080,"height":180,"angle":0,"strokeColor":"#047857","backgroundColor":"#d1fae5","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":201,"version":1,"versionNonce":2011,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"lane2","type":"text","x":60,"y":318,"width":170,"height":30,"angle":0,"strokeColor":"#065f46","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":202,"version":1,"versionNonce":2021,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"AGENTS.md 层级","fontSize":24,"fontFamily":1,"textAlign":"left","verticalAlign":"top","containerId":null,"originalText":"AGENTS.md 层级","lineHeight":1.25,"baseline":23},

    {"id":"a1r","type":"rectangle","x":85,"y":375,"width":180,"height":55,"angle":0,"strokeColor":"#047857","backgroundColor":"#ecfdf5","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":203,"version":1,"versionNonce":2031,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"a1","type":"text","x":98,"y":390,"width":154,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":204,"version":1,"versionNonce":2041,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"~/.codex/AGENTS.md","fontSize":18,"fontFamily":3,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"~/.codex/AGENTS.md","lineHeight":1.25,"baseline":18},
    {"id":"a2r","type":"rectangle","x":310,"y":375,"width":160,"height":55,"angle":0,"strokeColor":"#047857","backgroundColor":"#ecfdf5","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":205,"version":1,"versionNonce":2051,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"a2","type":"text","x":325,"y":390,"width":130,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":206,"version":1,"versionNonce":2061,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"/repo/AGENTS.md","fontSize":18,"fontFamily":3,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"/repo/AGENTS.md","lineHeight":1.25,"baseline":18},
    {"id":"a3r","type":"rectangle","x":515,"y":375,"width":215,"height":55,"angle":0,"strokeColor":"#047857","backgroundColor":"#ecfdf5","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":207,"version":1,"versionNonce":2071,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"a3","type":"text","x":530,"y":390,"width":185,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":208,"version":1,"versionNonce":2081,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"/repo/service/AGENTS.md","fontSize":18,"fontFamily":3,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"/repo/service/AGENTS.md","lineHeight":1.25,"baseline":18},
    {"id":"a4r","type":"rectangle","x":775,"y":375,"width":180,"height":55,"angle":0,"strokeColor":"#047857","backgroundColor":"#a7f3d0","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":209,"version":1,"versionNonce":2091,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"a4","type":"text","x":790,"y":390,"width":150,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":210,"version":1,"versionNonce":2101,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"当前目录 AGENTS.md","fontSize":18,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"当前目录 AGENTS.md","lineHeight":1.25,"baseline":18},
    {"id":"a5","type":"text","x":820,"y":438,"width":240,"height":25,"angle":0,"strokeColor":"#065f46","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":211,"version":1,"versionNonce":2111,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"更近目录更具体","fontSize":20,"fontFamily":1,"textAlign":"left","verticalAlign":"top","containerId":null,"originalText":"更近目录更具体","lineHeight":1.25,"baseline":20},

    {"id":"lane3-bg","type":"rectangle","x":40,"y":510,"width":520,"height":250,"angle":0,"strokeColor":"#7c3aed","backgroundColor":"#ede9fe","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":301,"version":1,"versionNonce":3011,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"lane3","type":"text","x":60,"y":528,"width":180,"height":30,"angle":0,"strokeColor":"#5b21b6","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":302,"version":1,"versionNonce":3021,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"Skill 加载与触发","fontSize":24,"fontFamily":1,"textAlign":"left","verticalAlign":"top","containerId":null,"originalText":"Skill 加载与触发","lineHeight":1.25,"baseline":23},
    {"id":"s1r","type":"rectangle","x":75,"y":585,"width":190,"height":48,"angle":0,"strokeColor":"#7c3aed","backgroundColor":"#faf5ff","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":303,"version":1,"versionNonce":3031,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"s1","type":"text","x":88,"y":597,"width":164,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":304,"version":1,"versionNonce":3041,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"启动时发现 Skill 清单","fontSize":18,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"启动时发现 Skill 清单","lineHeight":1.25,"baseline":18},
    {"id":"s2r","type":"rectangle","x":320,"y":585,"width":190,"height":48,"angle":0,"strokeColor":"#7c3aed","backgroundColor":"#faf5ff","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":305,"version":1,"versionNonce":3051,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"s2","type":"text","x":334,"y":597,"width":162,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":306,"version":1,"versionNonce":3061,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"只读名称 / 描述 / 路径","fontSize":18,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"只读名称 / 描述 / 路径","lineHeight":1.25,"baseline":18},
    {"id":"s3r","type":"rectangle","x":75,"y":670,"width":160,"height":48,"angle":0,"strokeColor":"#7c3aed","backgroundColor":"#faf5ff","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":307,"version":1,"versionNonce":3071,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"s3","type":"text","x":88,"y":682,"width":134,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":308,"version":1,"versionNonce":3081,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"用户请求触发匹配","fontSize":18,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"用户请求触发匹配","lineHeight":1.25,"baseline":18},
    {"id":"s4r","type":"rectangle","x":285,"y":670,"width":150,"height":48,"angle":0,"strokeColor":"#7c3aed","backgroundColor":"#ddd6fe","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":309,"version":1,"versionNonce":3091,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"s4","type":"text","x":302,"y":682,"width":116,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":310,"version":1,"versionNonce":3101,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"按需读取 SKILL.md","fontSize":18,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"按需读取 SKILL.md","lineHeight":1.25,"baseline":18},

    {"id":"lane4-bg","type":"rectangle","x":600,"y":510,"width":520,"height":250,"angle":0,"strokeColor":"#b45309","backgroundColor":"#fef3c7","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":401,"version":1,"versionNonce":4011,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"lane4","type":"text","x":620,"y":528,"width":180,"height":30,"angle":0,"strokeColor":"#92400e","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":402,"version":1,"versionNonce":4021,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"Tool / MCP 注入","fontSize":24,"fontFamily":1,"textAlign":"left","verticalAlign":"top","containerId":null,"originalText":"Tool / MCP 注入","lineHeight":1.25,"baseline":23},
    {"id":"m1r","type":"rectangle","x":630,"y":585,"width":170,"height":48,"angle":0,"strokeColor":"#b45309","backgroundColor":"#fffbeb","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":403,"version":1,"versionNonce":4031,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"m1","type":"text","x":643,"y":597,"width":144,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":404,"version":1,"versionNonce":4041,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"config.toml 中 MCP 定义","fontSize":17,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"config.toml 中 MCP 定义","lineHeight":1.25,"baseline":17},
    {"id":"m2r","type":"rectangle","x":850,"y":585,"width":170,"height":48,"angle":0,"strokeColor":"#b45309","backgroundColor":"#fffbeb","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":405,"version":1,"versionNonce":4051,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"m2","type":"text","x":865,"y":597,"width":140,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":406,"version":1,"versionNonce":4061,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"启动 / 连接 MCP Server","fontSize":17,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"启动 / 连接 MCP Server","lineHeight":1.25,"baseline":17},
    {"id":"m3r","type":"rectangle","x":630,"y":670,"width":170,"height":48,"angle":0,"strokeColor":"#b45309","backgroundColor":"#fffbeb","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":407,"version":1,"versionNonce":4071,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"m3","type":"text","x":644,"y":682,"width":142,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":408,"version":1,"versionNonce":4081,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"枚举 tools / resources","fontSize":17,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"枚举 tools / resources","lineHeight":1.25,"baseline":17},
    {"id":"m4r","type":"rectangle","x":850,"y":670,"width":180,"height":48,"angle":0,"strokeColor":"#b45309","backgroundColor":"#fde68a","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":409,"version":1,"versionNonce":4091,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"m4","type":"text","x":863,"y":682,"width":154,"height":25,"angle":0,"strokeColor":"#111827","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":410,"version":1,"versionNonce":4101,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"内置 tools + 插件 tools","fontSize":17,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"内置 tools + 插件 tools","lineHeight":1.25,"baseline":17},

    {"id":"note1r","type":"rectangle","x":70,"y":800,"width":470,"height":55,"angle":0,"strokeColor":"#6b7280","backgroundColor":"#f9fafb","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":501,"version":1,"versionNonce":5011,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"note1","type":"text","x":92,"y":815,"width":426,"height":25,"angle":0,"strokeColor":"#374151","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":502,"version":1,"versionNonce":5021,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"同名规则：personal skill 优先于 superpowers skill","fontSize":18,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"同名规则：personal skill 优先于 superpowers skill","lineHeight":1.25,"baseline":18},
    {"id":"note2r","type":"rectangle","x":600,"y":800,"width":500,"height":55,"angle":0,"strokeColor":"#6b7280","backgroundColor":"#f9fafb","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":3},"seed":503,"version":1,"versionNonce":5031,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false},
    {"id":"note2","type":"text","x":620,"y":815,"width":460,"height":25,"angle":0,"strokeColor":"#374151","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","roughness":0,"opacity":100,"groupIds":[],"frameId":null,"roundness":null,"seed":504,"version":1,"versionNonce":5041,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"text":"冲突规则：system/developer > config/CLI > AGENTS > skill > user request","fontSize":17,"fontFamily":1,"textAlign":"center","verticalAlign":"middle","containerId":null,"originalText":"冲突规则：system/developer > config/CLI > AGENTS > skill > user request","lineHeight":1.25,"baseline":17},

    {"id":"ar1","type":"arrow","x":210,"y":198,"width":40,"height":0,"angle":0,"strokeColor":"#1e40af","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":601,"version":1,"versionNonce":6011,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[40,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},
    {"id":"ar2","type":"arrow","x":440,"y":198,"width":40,"height":0,"angle":0,"strokeColor":"#1e40af","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":602,"version":1,"versionNonce":6021,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[40,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},
    {"id":"ar3","type":"arrow","x":590,"y":198,"width":40,"height":0,"angle":0,"strokeColor":"#1e40af","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":603,"version":1,"versionNonce":6031,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[40,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},
    {"id":"ar4","type":"arrow","x":750,"y":198,"width":40,"height":0,"angle":0,"strokeColor":"#1e40af","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":604,"version":1,"versionNonce":6041,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[40,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},
    {"id":"ar5","type":"arrow","x":900,"y":198,"width":40,"height":0,"angle":0,"strokeColor":"#1e40af","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":605,"version":1,"versionNonce":6051,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[40,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},

    {"id":"aa1","type":"arrow","x":265,"y":403,"width":45,"height":0,"angle":0,"strokeColor":"#047857","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":606,"version":1,"versionNonce":6061,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[45,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},
    {"id":"aa2","type":"arrow","x":470,"y":403,"width":45,"height":0,"angle":0,"strokeColor":"#047857","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":607,"version":1,"versionNonce":6071,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[45,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},
    {"id":"aa3","type":"arrow","x":730,"y":403,"width":45,"height":0,"angle":0,"strokeColor":"#047857","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":608,"version":1,"versionNonce":6081,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[45,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},

    {"id":"sa1","type":"arrow","x":265,"y":609,"width":55,"height":0,"angle":0,"strokeColor":"#7c3aed","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":609,"version":1,"versionNonce":6091,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[55,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},
    {"id":"sa2","type":"arrow","x":235,"y":694,"width":50,"height":0,"angle":0,"strokeColor":"#7c3aed","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":610,"version":1,"versionNonce":6101,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[50,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},

    {"id":"ma1","type":"arrow","x":800,"y":609,"width":50,"height":0,"angle":0,"strokeColor":"#b45309","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":611,"version":1,"versionNonce":6111,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[50,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},
    {"id":"ma2","type":"arrow","x":715,"y":633,"width":0,"height":37,"angle":0,"strokeColor":"#b45309","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":612,"version":1,"versionNonce":6121,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[0,37]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"},
    {"id":"ma3","type":"arrow","x":800,"y":694,"width":50,"height":0,"angle":0,"strokeColor":"#b45309","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"groupIds":[],"frameId":null,"roundness":{"type":2},"seed":613,"version":1,"versionNonce":6131,"isDeleted":false,"boundElements":null,"updated":1,"link":null,"locked":false,"points":[[0,0],[50,0]],"lastCommittedPoint":null,"startBinding":null,"endBinding":null,"startArrowhead":null,"endArrowhead":"arrow"}
  ],
  "appState": {
    "theme": "light",
    "viewBackgroundColor": "#ffffff",
    "currentItemStrokeColor": "#1f2937",
    "currentItemBackgroundColor": "transparent",
    "currentItemFillStyle": "solid",
    "currentItemStrokeWidth": 2,
    "currentItemStrokeStyle": "solid",
    "currentItemRoughness": 1,
    "currentItemOpacity": 100,
    "currentItemFontFamily": 1,
    "currentItemFontSize": 20,
    "currentItemTextAlign": "left",
    "currentItemStartArrowhead": null,
    "currentItemEndArrowhead": "arrow",
    "scrollX": 120,
    "scrollY": 40,
    "zoom": {"value": 0.85},
    "gridSize": null
  },
  "files": {}
}
```
%%
