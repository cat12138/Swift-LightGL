
#version 300 core

layout (location = 1) in float pSize;


void main(void) {
    gl_Position = vec4(d_Vertex, 1.0);
    gl_PointSize = pSize;
}

