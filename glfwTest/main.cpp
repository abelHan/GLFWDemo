

#if defined(__APPLE__)
#include <OpenGL/gl3.h>
#else
#include <glew/glew.h>
#endif


#include "glfw/glfw3.h"
#include <stdio.h>

#ifdef _MSC_VER
#define snprintf _snprintf
#endif

// This include was added to support MinGW
#ifdef _WIN32
#include <crtdbg.h>
#endif

void glfwErrorCallback(int error, const char *description)
{
	fprintf(stderr, "GLFW error occured. Code: %d. Description: %s\n", error, description);
}

int main(int, char**)
{
#if defined(_WIN32)
	// Enable memory-leak reports
	_CrtSetDbgFlag(_CRTDBG_LEAK_CHECK_DF | _CrtSetDbgFlag(_CRTDBG_REPORT_FLAG));
#endif

	glfwSetErrorCallback(glfwErrorCallback);

	if (glfwInit() == 0)
	{
		fprintf(stderr, "Failed to initialize GLFW\n");
		return -1;
	}

#if defined(__APPLE__)
	// Without these settings on macOS, OpenGL 2.1 will be used by default which will cause crashes at boot.
	// This code is a slightly modified version of the code found here: http://www.glfw.org/faq.html#how-do-i-create-an-opengl-30-context
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
#endif

	int m_width = 1024;
	int m_height = 640;

	char title[64];
	sprintf(title, "glfwTest");

	GLFWwindow * mainWindow = glfwCreateWindow(m_width, m_height, title, NULL, NULL);
	if (mainWindow == NULL)
	{
		fprintf(stderr, "Failed to open GLFW mainWindow.\n");
		glfwTerminate();
		return -1;
	}

	glfwMakeContextCurrent(mainWindow);
	printf("OpenGL %s, GLSL %s\n", glGetString(GL_VERSION), glGetString(GL_SHADING_LANGUAGE_VERSION));

	// glfwSetScrollCallback(mainWindow, sScrollCallback);
	// glfwSetWindowSizeCallback(mainWindow, sResizeWindow);
	// glfwSetKeyCallback(mainWindow, sKeyCallback);
	// glfwSetCharCallback(mainWindow, sCharCallback);
	// glfwSetMouseButtonCallback(mainWindow, sMouseButton);
	// glfwSetCursorPosCallback(mainWindow, sMouseMotion);
	// glfwSetScrollCallback(mainWindow, sScrollCallback);

#if defined(__APPLE__) == FALSE
	//glewExperimental = GL_TRUE;
	GLenum err = glewInit();
	if (GLEW_OK != err)
	{
		fprintf(stderr, "Error: %s\n", glewGetErrorString(err));
		return 1;
		// exit(EXIT_FAILURE);
	}
#endif


	// Control the frame rate. One draw per monitor refresh.
	glfwSwapInterval(1);

	double time1 = glfwGetTime();
	double frameTime = 0.0;
   
	glClearColor(0.3f, 0.3f, 0.3f, 1.f);
	
	while (!glfwWindowShouldClose(mainWindow))
	{
		glfwGetWindowSize(mainWindow, &m_width, &m_height);
        
        int bufferWidth, bufferHeight;
        glfwGetFramebufferSize(mainWindow, &bufferWidth, &bufferHeight);
        glViewport(0, 0, bufferWidth, bufferHeight);

		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		// Measure speed
		double time2 = glfwGetTime();
		double alpha = 0.9f;
		frameTime = alpha * frameTime + (1.0 - alpha) * (time2 - time1);
		time1 = time2;


		glfwSwapBuffers(mainWindow);

		glfwPollEvents();
	}

	glfwTerminate();

	return 0;

}
