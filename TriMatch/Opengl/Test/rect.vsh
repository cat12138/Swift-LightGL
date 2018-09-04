
#version 300 core

precision highp float;

layout(location = 0) in vec2 pos;

layout(location = 1) in vec4 color;
out vec4 vColor;

layout(location = 2) in vec2 uv;
out vec2 vUV;

void main() {
    gl_Position = vec4(pos.x, -pos.y, 0.0, 1.0);
    vColor = color;
    vUV = uv;
}



