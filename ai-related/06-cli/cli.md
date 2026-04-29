全称：command line interface
# cli的优势
## 1、token消耗小
MCP的tioken消耗大；
 MCP的元信息（name，description，schema等）传到context中，token消耗大
 安装的mcp越多，就会导致占用的context越多，消耗的token越多；
 cli的token消耗小；
 每次只需在cli中加入bash相关的信息到context中并给到LLM，
## 2、执行效率高
## MCP模式的做法：
![[call_mcp_flow.png]]
## cli模式的做法；
![[call_cli_flow.png]]
cli只需要调用bash，然后内部自由组合，非常高效；
# MCP优势：
1、更可控
2、更安全：cli可能会误删除
# 未来趋势
大部分使用cli，小部分需要MCP；不存在全面替代
 
