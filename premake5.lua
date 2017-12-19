--[[
    github: https://github.com/premake/premake-core
    Tutorials: https://github.com/premake/premake-core/wiki
    
    关键字都是函数名, 参数为常量时可以省略括号
    编译命令行： premake5 --file=MyProjectScript.lua vs2017 (--file 可省略)
--]]

workspace "GLFWDemo"
--[[
    https://github.com/premake/premake-core/wiki/workspace
    VS中创建解决方案
--]]
    location ( "Build/%{_ACTION}" )
    --[[
        https://github.com/premake/premake-core/wiki/location
        VS指定.sln 等工程文件的路径
        _ACTION 全局变量 The action that will be run
        eg: 执行命令行 premake5 vs2017 后 _ACTION == "vs2017"
    --]]
    architecture "x86_64"
    --[[
        https://github.com/premake/premake-core/wiki/architecture
        指定系统框架
        architecture ("value")
        value:
            x86
            x86_64
            ARM
        eg:
            workspace "MyWorkspace"
               configurations { "Debug32", "Release32", "Debug64", "Release64" }

               filter "configurations:*32"
                  architecture "x86"

               filter "configurations:*64"
                  architecture "x86_64"

    --]]
    configurations { "Debug", "Release" }
    --[[
        https://github.com/premake/premake-core/wiki/configurations
        指定工作区或项目的生成配置集，如“调试”和“发布”
    --]]

    configuration "vs*"
        defines { "_CRT_SECURE_NO_WARNINGS" }
    --[[
        configuration
            https://github.com/premake/premake-core/wiki/configuration
            仅在针对visual studio时定义符号
            作用雷同：filter
            eg:
                configuration "not windows"
                configuration "linux or macosx"

        defines : 预处理器或编译器符号
    --]]

    filter "configurations:Debug"
        targetdir ( "Build/%{_ACTION}/bin/Debug" )
        defines { "DEBUG" }
        symbols "On"
    --[[
        filter:
            https://github.com/premake/premake-core/wiki/filter
            Limits the subsequent build settings to a particular environment
            eg:
                -- (configurations == "Debug") and (kind == SharedLib or kind == "StaticLib")
                filter { "Debug", "kind:SharedLib or StaticLib" }
                  targetsuffix "_d"

                -- Could also be written as
                filter { "Debug", "kind:*Lib" }
                  targetsuffix "_d"
    --]]

    --[[
        targetdir : https://github.com/premake/premake-core/wiki/targetdir
        设置已编译二进制目标的目标目录
    --]]

    --[[
        symbols: https://github.com/premake/premake-core/wiki/symbols
        Turn on/off debug symbol table generation.
    --]]

    filter "configurations:Release"
        targetdir ( "Build/%{_ACTION}/bin/Release" )
        defines { "NDEBUG" }
        optimize "On"
    --[[
        optimize: https://github.com/premake/premake-core/wiki/optimize
        优化函数指定构建目标配置时使用的优化级别和类型
    --]]

    filter { "language:C++", "toolset:gcc" }
        buildoptions { "-std=c++11" }
    --[[
        buildoptions: https://github.com/premake/premake-core/wiki/buildoptions
        不经翻译直接将参数传递到编译器命令行
    --]]

project "GLEW"
    kind "StaticLib"
    language "C++"
    defines { "GLEW_STATIC" }
    files { "glew/*.h", "glew/*.c" }
    includedirs { "." }
--[[
    kind: https://github.com/premake/premake-core/wiki/kind
    kind ("kind")
        ConsoleApp  A console or command-line application.
        WindowedApp An application which runs in a desktop window. 
                This distinction does not apply on Linux, but is important on Windows and Mac OS X.
        SharedLib   A shared library or DLL.
        StaticLib   A static library.
        Makefile    A special configuration type which calls out to one or more external commands.
                 The actual type of binary created is unspecified. See Makefile Projects for more information.
        Utility A configuration which contains only custom build rules.
        None    A configuration which is not included in the build. Useful for projects containing 
                only web pages, header files, or support documentation.
    eg:
        workspace "MyWorkspace"
           configurations { "DebugLib", "DebugDLL", "ReleaseLib", "ReleaseDLL" }

        project "MyProject"

           filter "*Lib"
              kind "StaticLib"

           filter "*DLL"
              kind "SharedLib"
--]]

--[[
    language: https://github.com/premake/premake-core/wiki/language
    language ("lang")
        C   Built-in; always available
        C++ Built-in; always available
        C#  Built-in; always available
        F#  Built-in; always available
        D   Built-in; always available
--]]

--[[
    files: https://github.com/premake/premake-core/wiki/files
    相反：removefiles
    eg:
        files {
           "hello.h",  -- you can specify exact names
           "*.c",      -- 当前文件夹中匹配
           "**.cpp"    -- 当前文件夹及其所有子文件夹中匹配
        }
--]]

--[[
    includedirs: https://github.com/premake/premake-core/wiki/includedirs
    设置头文件包含路径
    includedirs { "." } 当前路径
--]]

project "GLFW"
    kind "StaticLib"
    language "C"
    files {
        "glfw/internal.h",
        "glfw/glfw_config.h",
        "glfw/glfw3.h",
        "glfw/glfw3native.h",
        "glfw/context.c",
        "glfw/init.c",
        "glfw/input.c",
        "glfw/monitor.c",
        "glfw/vulkan.c",
        "glfw/window.c" }

    configuration { "windows" }
        files {
            "glfw/win32_platform.h",
            "glfw/win32_joystick.h",
            "glfw/wgl_context.h",
            "glfw/egl_context.h",
            "glfw/win32_init.c",
            "glfw/win32_joystick.c",
            "glfw/win32_monitor.c",
            "glfw/win32_time.c",
            "glfw/win32_tls.c",
            "glfw/win32_window.c",
            "glfw/wgl_context.c",
            "glfw/egl_context.c"
        }

    configuration { "macosx" }
        files {
            "glfw/cocoa_platform.h",
            "glfw/iokit_joystick.h",
            "glfw/posix_tls.h",
            "glfw/nsgl_context.h",
            "glfw/egl_context.h",
            "glfw/cocoa_init.m",
            "glfw/cocoa_joystick.m",
            "glfw/cocoa_monitor.m",
            "glfw/cocoa_window.m",
            "glfw/cocoa_time.c",
            "glfw/posix_tls.c",
            "glfw/nsgl_context.m",
            "glfw/egl_context.c"
        }

    configuration { "not windows", "not macosx" }
        files {
            "glfw/x11_platform.h",
            "glfw/xkb_unicode.h",
            "glfw/linux_joystick.h",
            "glfw/posix_time.h",
            "glfw/posix_tls.h",
            "glfw/glx_context.h",
            "glfw/egl_context.h",
            "glfw/x11_init.c",
            "glfw/x11_monitor.c",
            "glfw/x11_window.c",
            "glfw/glx_context.h",
            "glfw/glx_context.c",
            "glfw/glext.h",
            "glfw/xkb_unicode.c",
            "glfw/linux_joystick.c",
            "glfw/posix_time.c",
            "glfw/posix_tls.c",
            "glfw/glx_context.c",
            "glfw/egl_context.c"
        }

project "glfwTest"
    kind "ConsoleApp"
    language "C++"
    defines {"GLEW_STATIC"}
    files {"glfwTest/**.h","glfwTest/**.cpp"}
    includedirs {"."}
    links {"GLFW", "GLEW"}
	configuration { "windows" }
        links { "GLEW", "glu32", "opengl32", "winmm" }
    configuration { "macosx" }
        defines { "GLFW_INCLUDE_GLCOREARB" }
        links { "OpenGL.framework", "Cocoa.framework", "IOKit.framework", "CoreFoundation.framework", "CoreVideo.framework"}
    configuration { "gmake" }
        links { "GL", "GLU", "GLEW", "X11", "Xrandr", "Xinerama", "Xcursor", "pthread", "dl" }

--[[
    links: https://github.com/premake/premake-core/wiki/links
    指定要链接的库和项目列表
--]]
