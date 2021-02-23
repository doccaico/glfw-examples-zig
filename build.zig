const Builder = @import("std").build.Builder;
const builtin = @import("builtin");

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    {
        const name = "01-window";
        const exe = b.addExecutable(name, name ++ "/main.zig");
        exe.setBuildMode(mode);

        exe.linkSystemLibrary("c");
        exe.linkSystemLibrary("GL");
        exe.linkSystemLibrary("glfw3");

        const run_cmd = exe.run();

        const lists = [_][2][]const u8{
            [_][]const u8{ name, "Run " ++ name },
        };

        for (lists) |list| {
            const run_step = b.step(list[0], list[1]);
            run_step.dependOn(&run_cmd.step);
        }
    }
    {
        const name = "02-hello";
        const exe = b.addExecutable(name, name ++ "/main.zig");
        exe.setBuildMode(mode);

        const run_cmd = exe.run();

        const lists = [_][2][]const u8{
            [_][]const u8{ name, "Run " ++ name },
        };

        for (lists) |list| {
            const run_step = b.step(list[0], list[1]);
            run_step.dependOn(&run_cmd.step);
        }
    }
}
