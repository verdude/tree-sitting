const jsfile = @This();

const std = @import("std");

buf: []const u8,
pos: u64,
alloc: std.mem.Allocator,

pub const ReadError = error{ InvalidPosition, EOF };

pub fn load(filename: []const u8, alloc: std.mem.Allocator) !jsfile {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    const filestat = try file.stat();
    const buf: []u8 = try alloc.alloc(u8, filestat.size);
    const uread = try file.readAll(buf);
    if (uread < filestat.size) {
        std.log.warn("Only read {d} bytes.", .{uread});
    } else {
        std.log.debug("Read {d} bytes.", .{uread});
    }
    return .{ .buf = buf, .pos = 0, .alloc = alloc };
}

pub fn read_maybe(self: *jsfile, len: u64, update: bool) ReadError!?[]const u8 {
    const end_offset = len + self.pos;
    if (self.pos > self.buf.len) {
        return ReadError.InvalidPosition;
    } else if (self.pos == self.buf.len) {
        return null;
    }
    if (update) {
        defer self.pos = end_offset;
    }
    return self.buf[self.pos..end_offset];
}

pub fn read(self: *jsfile, len: u64) ReadError![]const u8 {
    return try self.read_maybe(len, true) orelse ReadError.EOF;
}

pub fn peek(self: *jsfile, len: u64) ReadError![]const u8 {
    return try self.read_maybe(len, false) orelse ReadError.EOF;
}

pub fn unload(self: *jsfile) void {
    self.alloc.free(self.buf);
}
