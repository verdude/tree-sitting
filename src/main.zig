const std = @import("std");

const lib = @import("tree_sitting_lib");
const ts = @import("tree-sitter");
const args = @import("args.zig");
const jsfile = @import("js_file.zig");
const ReadError = jsfile.ReadError;

extern fn tree_sitter_javascript() callconv(.C) *ts.Language;

fn load_file(al: std.mem.Allocator) !jsfile {
    var ar = args.init();
    try ar.parse();
    const filename = ar.file orelse return error.MissingRequiredFileArg;
    return try jsfile.load(filename, al);
}

pub fn main() !void {
    var gpai = std.heap.GeneralPurposeAllocator(.{}){};
    var gpa = gpai.allocator();
    defer {
        const deinit_status = gpai.deinit();
        if (deinit_status == .leak) {
            std.log.err("mem leak", .{});
        }
    }

    var file = try load_file(gpa);
    defer file.unload();

    const language = tree_sitter_javascript();
    defer language.destroy();

    const parser = ts.Parser.create();
    defer parser.destroy();

    try parser.setLanguage(language);

    // Parse some source code and get the root node
    const tree = parser.parseString(file.buf, null).?;
    defer tree.destroy();

    const node = tree.rootNode();
    var cursor = node.walk();
    std.log.debug("Child count: {d}", .{node.childCount()});
    const children = try node.children(&cursor, &gpa);
    for (children) |c| {
        std.log.debug("Child: {s}", .{ts.Node.ts_node_string(c)});
    }

    // Create a query and execute it
    // var error_offset: u32 = 0;
    // const query = try ts.Query.create(language, "name: (identifier) @name", &error_offset);
    // defer query.destroy();
    // const cursor = ts.QueryCursor.create();
    // defer cursor.destroy();
    // cursor.exec(query, node);

    // Get the captured node of the first match
    // const match = cursor.nextMatch().?;
    // const capture = match.captures[0].node;
    // std.debug.assert(std.mem.eql(u8, capture.type(), "identifier"));
}
