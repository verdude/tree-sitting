/// The latest ABI version that is supported by the current version of the library.
///
/// The Tree-sitter library is generally backwards-compatible with
/// languages generated using older CLI versions, but is not forwards-compatible.
pub const LANGUAGE_VERSION = 15;

/// The earliest ABI version that is supported by the current version of the library.
pub const MIN_COMPATIBLE_LANGUAGE_VERSION = 13;

const language = @import("language.zig");
const parser = @import("parser.zig");
const tree = @import("tree.zig");

pub const set_allocator = @import("alloc.zig").ts_set_allocator;

pub const Language = language.Language;
pub const LanguageMetadata = language.LanguageMetadata;
pub const LookaheadIterator = @import("lookahead_iterator.zig").LookaheadIterator;
pub const Node = @import("node.zig").Node;
pub const Input = parser.Input;
pub const InputEdit = tree.InputEdit;
pub const Logger = parser.Logger;
pub const Parser = parser.Parser;
pub const Tree = tree.Tree;
pub const TreeCursor = @import("tree_cursor.zig").TreeCursor;
pub const Query = @import("query.zig").Query;
pub const QueryCursor = @import("query_cursor.zig").QueryCursor;

const structs = @import("point.zig");
pub const Point = structs.Point;
pub const Range = structs.Range;
