const ts = @import("tree-sitter");

extern fn tree_sitter_javascript() callconv(.C) *ts.Language;
extern fn ts_node_string(self: ts.Node) [*c]u8;
extern fn ts_node_type(self: ts.Node) [*:0]const u8;
