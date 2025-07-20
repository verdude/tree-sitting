const Splitter = @This();

const std = @import("std");
const Model = @import("models.zig").Model;
const ts = @import("tree-sitter");
const ts_fn = @import("sitter-reexport.zig");

const Splitten = union(enum) {
    single: ts.Range,
    muchos: std.ArrayList(ts.Range),
};

model: Model,
cursor: *ts.TreeCursor,
alloc: std.heap.ArenaAllocator,

fn ninos(self: *Splitter) !Splitten {
    var group_total = 0;
    const children = try self.cursor.node().children(self.cursor, &self.alloc);
    for (children.items) |child| {
        const r = child.range();
        const tokens = self.model.tokens(r.end_byte - r.start_byte);
        group_total += tokens;
        std.log.debug(
            "Length of [{s}]: {d}. Group: {d}",
            .{
                ts_fn.ts_node_type(child),
                tokens,
                group_total,
            },
        );
        if (group_total < self.model.target) {
            return Splitten{ .single = r };
        }
    }
    return children;
}

pub fn init(model: Model, cursor: *ts.TreeCursor, alloc: *std.mem.Allocator) Splitter {
    return .{
        .model = model,
        .cursor = cursor,
        .alloc = std.heap.ArenaAllocator(alloc.*),
    };
}
