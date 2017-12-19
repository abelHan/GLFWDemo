
#注意点
1. 关键字都是函数名, 参数为常量时可以省略括号

2. 编译命令行： premake5 --file=MyProjectScript.lua vs2013

3. 关键字 用法实例
	defines 
	removedefines
	language

	workspace 
	eg:
		workspace "HelloWorld"
		filename "Hello"
		configurations { "Debug", "Release" }

		filter "configurations:Debug"
			defines { "DEBUG" }
			flags { "Symbols" }

		filter "configurations:Release"
			defines { "NDEBUG" }
			optimize "On"

	project
	eg:
		project "MyProject"
		   kind "ConsoleApp"/"StaticLib"
		   language "C++"/"C"

	location
	eg:
		location( "Build/%{_ACTION}")
		运行 premake5 vs2013 时
		_ACTION == "vs2013"

	files/removefiles
	eg:
		files {
		   "hello.h",  -- you can specify exact names
		   "*.c",      -- 当前文件夹中匹配
		   "**.cpp"    -- 当前文件夹及其所有子文件夹中匹配
		}

	links -- 链接到外部库
	eg:
		links {"GLFW", "GLEW"}

	libdirs -- 指定外部库目录
	eg:
		libdirs { os.findlib("xxxx") }

注：
1. premake5 wiki : https://github.com/premake/premake-core/wiki
2. premake5 函数说明: https://github.com/premake/premake-core/wiki/Project-API
