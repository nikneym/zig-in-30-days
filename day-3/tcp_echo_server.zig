// way too simple TCP server that can handle only 1 connection at a time
const std = @import("std");
const net = std.net;
const print = std.debug.print;

pub fn main() !void {
  var server = net.StreamServer.init(.{ .reuse_address = true });
  defer server.deinit();

  try server.listen(try net.Address.parseIp4("127.0.0.1", 8080));

  while (true) {
    const client = try server.accept();
    try handle_client(&client.stream);
  }

  unreachable;
}

fn handle_client(stream: *const net.Stream) !void {
  defer stream.close();

  while (true) {
    var buf: [100]u8 = undefined;
    const n = try stream.read(&buf);
    print("{s}\n", .{ buf });

    if (n == 0)
      break;
  }
}