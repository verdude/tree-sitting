const std = @import("std");

const lib = @import("tree_sitting_lib");
const ts = @import("tree-sitter");
const args = @import("args.zig");
const jsfile = @import("js_file.zig");
const ReadError = jsfile.ReadError;
const models = @import("models.zig");
const Model = models.Model;
const ts_fn = @import("sitter-reexport.zig");
const Splitter = @import("split.zig");

fn load_file(al: std.mem.Allocator) !jsfile {
    var ar = args.init();
    try ar.parse();
    const filename = ar.file orelse return error.MissingRequiredFileArg;
    return try jsfile.load(filename, al);
}

fn cost(bytes: f32, cmpt: f32) f32 {
    return bytes / 1_000_000 * cmpt;
}

pub fn main() !void {
    var gpai = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = gpai.allocator();
    defer {
        const deinit_status = gpai.deinit();
        if (deinit_status == .leak) {
            std.log.err("mem leak", .{});
        }
    }

    var file = try load_file(gpa);
    defer file.unload();

    const language = ts_fn.tree_sitter_javascript();
    defer language.destroy();

    const parser = ts.Parser.create();
    defer parser.destroy();

    try parser.setLanguage(language);

    const tree = parser.parseString(file.buf, null).?;
    defer tree.destroy();

    const node = tree.rootNode();
    var cursor = node.walk();
    std.log.debug("Root: {s}", .{ts_fn.ts_node_type(node)});

    // ninos mem
    const size = 1024 * 5;
    var fba_buf: [size]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&fba_buf);
    var stackalloc = fba.allocator();

    var splitter = Splitter.init(models.gpt41(), &cursor, &stackalloc);
    const chunks = try splitter.ninos(&cursor);
    std.log.debug("done? {?}", .{chunks});
}
