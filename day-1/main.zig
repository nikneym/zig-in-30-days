const std = @import("std");
const assert = std.debug.assert;

// stdout in C, might fail so it must be error checked
// when called
const stdout = std.io.getStdOut().writer();

// std.debug.print never fails!
const print = std.debug.print;

// bang on the return type means this function might
// return an err
pub fn main() !void {
  // built-in type names are similar to those of rust
  const lucky_number: i32 = 7;
  const division: f32 = 150 / 30.30;
  try stdout.print("{d}, {d}\n", .{lucky_number, division});

  // verbose logical operators like in lua
  if (lucky_number == 7 and 10 / 5 == 2) {
    try stdout.print("makes sense!\n", .{});
  }

  // optionals
  var optional: ?[] const u8 = null;

  try stdout.print("{s}, {s}\n", .{
    @typeName(@TypeOf(optional)),
    optional,
  });

  optional = "nikneym";
  assert(optional != null);

  // similar to NULLable(?) values but these may throw
  // errors as far as I understood
  var errorable: anyerror!i32 = error.ArgNotFound;
  print("error union {s}, {}\n", .{
    @typeName(@TypeOf(errorable)),
    errorable,
  });

  // comptime_int
  print("{}\n", .{@TypeOf(5)});

  // i32
  const i: i32 = 5;
  print("{}\n", .{@TypeOf(i)});

  // might look similar to first one BUT compiler tells
  // it's i32
  print("{}\n", .{@TypeOf(@as(i32, 5))});
}
