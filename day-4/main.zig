const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const Point = struct {
  x: i32,
  y: i32
};

// the `Point` passed here can be either value or reference
// decision is made by zig
fn foo(point: Point) i32 {
  print("{}\n", .{ @TypeOf(point) });
  return point.x + point.y;
}

// though here we explicitly want the reference to the point
fn bar(point: *const Point) i32 {
  print("{}\n", .{ @TypeOf(point) });
  return point.x + point.y;
}

fn allocatePoint(allocator: Allocator, x: i32, y: i32) !*Point {
  var point = try allocator.create(Point);
  point.x = x;
  point.y = y;

  return point;
}

pub fn main() !void {
  var point = Point{.x = 100, .y = 207};

  var result: i32 = foo(point);
  print("{d}\n", .{ result });

  result = bar(&point);
  print("{d}\n", .{ result });

  // there are more than one allocators to use in zig
  // init GeneralPurposeAllocator
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  defer _ = gpa.deinit();

  // allocator object that'll be used at more than one place
  const allocator = gpa.allocator();

  // allocators are passed as an arg
  var new_point = try allocatePoint(allocator, 100, 120);

  print("{}, {}\n", .{ new_point, new_point.* });
  print("{}, {}\n", .{ @TypeOf(new_point), @TypeOf(new_point.*) });

  defer allocator.destroy(new_point);
}