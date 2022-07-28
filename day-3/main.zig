const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;

const Person = struct {
  name: []const u8,
  job:  []const u8,
  age:  i32,

  pub fn info(self: *Person) !i32 {
    print("{s}, {s}\n", .{ self.name, self.job });

    if (self.age > 25) {
      return error.ageIsBiggerThan25;
    }

    return self.age;
  }
};

pub fn main() !void {
  var people = [_]Person{
    .{ .name = "John", .job = "Lawyer", .age = 37 },
    .{ .name = "Nathan", .job = "Student", .age = 23 },
  };

  for (people) |*person| {
    const age: i32 = person.info() catch |err| blk: {
      print("failed with {}\n", .{ err });

      break :blk 25;
    };

    print("new age: {d}\n", .{ age });
  }
}