const Model = struct {
    name: []const u8,
    batch_cpmit: f32,
    batch_cpmot: f32,
    window: usize,
    max_out: usize,
    target: usize = 1024 * 2,

    pub fn tokens(bytes: usize) usize {
        return bytes / 3;
    }
};

pub fn gpt41() Model {
    return .{
        .name = "gpt-4.1",
        .batch_cpmit = 1.00,
        .batch_cpmot = 4.00,
        .window = 1_047_576,
        .max_out = 32_768,
    };
}

pub fn gpto3() Model {
    return .{
        .name = "gpt-o3",
        .batch_cpmit = 1.00,
        .batch_cpmot = 4.00,
        .window = 1_047_576,
        .max_out = 32_768,
    };
}
