const std = @import("std");
const warn = std.debug.warn;
const panic = std.debug.panic;

const c = @import("c.zig");

// const c = @cImport({
//     @cInclude("GL/glew.h");
//     @cInclude("GLFW/glfw3.h");
// });

// zig build-exe main.zig -lc -lGL -lglfw

fn errorCallback(err: c_int, description: [*c]const u8) callconv(.C) void {
    panic("Error: {s}\n", .{description});
}

fn keyCallback(win: ?*c.GLFWwindow, key: c_int, scancode: c_int, action: c_int, mods: c_int) callconv(.C) void {
    if (action != c.GLFW_PRESS) return;

    switch (key) {
        c.GLFW_KEY_Q => c.glfwSetWindowShouldClose(win, c.GLFW_TRUE),
        c.GLFW_KEY_ESCAPE => c.glfwSetWindowShouldClose(win, c.GLFW_TRUE),
        else => {},
    }
}

var window: ?*c.GLFWwindow = undefined;

pub fn main() u8 {
    _ = c.glfwSetErrorCallback(errorCallback);

    if (c.glfwInit() == c.GLFW_FALSE) {
        panic("Failed to initialize GLFW\n", .{});
    }
    defer c.glfwTerminate();

    c.glfwWindowHint(c.GLFW_SAMPLES, 4); // 4x antialiasing
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_FORWARD_COMPAT, c.GLFW_TRUE);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);
    c.glfwWindowHint(c.GLFW_RESIZABLE, c.GLFW_FALSE);

    window = c.glfwCreateWindow(300, 300, "Title", null, null) orelse {
        panic("unable to create window\n", .{});
    };
    defer c.glfwDestroyWindow(window);

    _ = c.glfwSetKeyCallback(window, keyCallback);
    c.glfwMakeContextCurrent(window);
    c.glfwSwapInterval(1);

    c.glClearColor(1.0, 1.0, 1.0, 0.0); // white

    // c.glfwSetInputMode(window, c.GLFW_STICKY_KEYS, c.GL_TRUE);

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        // c.draw();

        // Swap buffers
        c.glfwSwapBuffers(window);
        c.glfwPollEvents();

        // if (c.glfwWindowShouldClose(window) != 0 or
        //     c.glfwGetKey(window, c.GLFW_KEY_ESCAPE) == c.GLFW_PRESS) break;
    }

    return 0;
}
