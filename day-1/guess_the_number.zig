const std = @import("std");
const Random = std.rand.DefaultPrng;
const Instant = std.time.Instant;
const fmt = std.fmt;
const print = std.debug.print;

pub fn main() !void {
  const stdin = std.io.getStdIn().reader();
  const stdout = std.io.getStdOut().writer();

  // initialize the allocator
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  const allocator = gpa.allocator();

  // deinitialize the allocator
  defer _ = gpa.deinit();

  // use current nanosec for rand seed
  var instant = try Instant.now();
  const seed: u64 = @intCast(u64, instant.timestamp.tv_nsec);

  // generate a random number
  var prng = Random.init(seed);
  const magic_number: i32 = prng.random().intRangeAtMost(i32, 0, 100);

  // game loop
  while (true) {

    // read user input
    const till_line = try stdin.readUntilDelimiterAlloc(
      allocator,
      '\n',
      1024,
    );

    // free it when it got out of the scope
    defer allocator.free(till_line);

    const line = std.mem.trim(u8, till_line, "\r");

    // get integer value from user input
    var guess = fmt.parseInt(i32, line, 0) catch |err| switch (err) {
      error.Overflow => {
        print("integer overflow!\n", .{});
        continue;
      },

      error.InvalidCharacter => {
        print("type a number instead\n", .{});
        continue;
      },
    };

    // check how close player is to answer
    if (guess < magic_number) try stdout.print("Bigger!\n", .{});
    if (guess > magic_number) try stdout.print("Smaller!\n", .{});

    // check if player succeeded
    if (guess == magic_number) {
      try stdout.print("Correct! Number was {d}\n", .{magic_number});
      break;
    }

  } // game loop
}