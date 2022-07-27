const std = @import("std");
const expect = std.testing.expect;

pub fn main() !void {
  const stdout = std.io.getStdOut().writer();

  // variables in zig must be initialized
  var y: ?i32 = 72;

  // if y is not NULL, print it's value
  if (y) |value| {
    try stdout.print("{d}\n", .{value});
  }

  // y is uninitialized now
  y = undefined;

  try expect(@TypeOf(y) == ?i32);

  // variables with compile time known values
  comptime var x = 100;
  x += 50;

  if (x == 150)
    try stdout.print("{d}\n", .{x});

  // arrays with static length
  const odd_numbers = [5]i32{ 1, 3, 5, 7, 9 };
  try stdout.print("{any}\nlength: {d}\n", .{odd_numbers, odd_numbers.len});

  // string literal, same as [_]u8{}
  const message = "Hello";
  try stdout.print("{s} world!\n", .{message});

  // iterators
  // supports inline arrays!
  for ([4]i32{ 2, 4, 6, 8 }) |value, index| {
    try stdout.print("{d}\t{d}\n", .{value, index});
  }

  var modifiable = [_]i32{ 100, 200, 300, 400, 500 };

  for (modifiable) |*pValue| {
    // pointer to our array value
    // `.*` to dereference
    try stdout.print("{}, {d}\n", .{pValue, pValue.*});
  }

  // zero initialized array that has 10 elements
  const all_zero = [_]u16{0} ** 10;
  try stdout.print("{any}\n", .{all_zero});

  // compile time initialized array with labels!
  var fancy_array = init: {
    // uninitialized emtpy array
    var initial_value: [10]i32 = undefined;

    for (initial_value) |*p, i| {
      p.* = @intCast(i32, i);
    }

    // exit the block and push the value to label at the top
    break :init initial_value;
  };

  try stdout.print("{any}, len: {d}\n", .{
    fancy_array,
    fancy_array.len
  });
}