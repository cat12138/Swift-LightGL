
#version 300 core

precision highp float;

//layout(location = 0, index = 0) out vec4 color;
in vec4 vColor;
out vec4 fColor;

uniform float showTex;
uniform sampler2D tex;
in vec2 vUV;

void main() {
    if (showTex == 1.0) {
        fColor = texture(tex, vUV);
    } else {
        fColor = vColor;
    }
    
}



/*
//ubo
//1 - 定义
uniform BlobSettings {
    vec4 InnerColor;
    vec4 OuterColor;
    float RadiusInner;
    float RadiusOuter;
};
//Block中的变量依然是全局域的一部分，取用的时候不用Block名。

uniform BlobSettings{
    vec4 InnerColor;
    vec4 OuterColor;
    float RadiusInner;
    float RadiusOuter;
}Blob;
//Block中的变量则是在Blob名字域中，取用的时候需要加上Block名
*/



//2 - 调用
/*
let blockIndex: GLuint = glGetUniformBlockIndex(program, "BlobSetting")

var blockDataSize: GLuint = 0
glGetActiveUniformBlockiv(program, blockIndex, GLenum(GL_UNIFORM_BLOCK_DATA_SIZE), &blockDataSize)

var ubo: GLuint = 0
glGenBuffers(1, &ubo)
glBindBuffer(GLenum(GL_UNIFORM_BUFFER), ubo)
glBufferData(GLenum(GL_UNIFORM_BUFFER), blockDataSize, nil, GLenum(GL_DYNAMIC_DRAW))

glBindBufferRange(GLenum(GL_UNIFORM_BUFFER), 0, ubo, 0, blockDataSize)
glUniformBlockBinding(program, blockIndex, 0)
glBindBuffer(GLenum, 0)
 */



