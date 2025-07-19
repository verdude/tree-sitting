const std = @import("std");
const os = std.os;
const mem = std.mem;

fn is_option(arg: []const u8, long: []const u8, short: []const u8) bool {
    if (arg.len == long.len) return mem.eql(u8, arg, long);
    if (arg.len == short.len) return mem.eql(u8, arg, short);
    return false;
}

pub const CliArgs = struct {
    file: ?[]const u8,

    pub fn parse(self: *CliArgs) !void {
        var argi = std.process.ArgIteratorPosix.init();
        _ = argi.next();
        self.file = argi.next();
    }
};

pub fn init() CliArgs {
    return .{
        .file = null,
    };
}
