const std = @import("std");

const lib = @import("tree_sitting_lib");
const ts = @import("tree-sitter");

pub fn main() !void {
    const parser = ts.Parser.create();
    defer parser.destroy();
}
