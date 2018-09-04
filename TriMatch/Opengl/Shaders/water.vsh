
#version 300 core

precision highp float;


layout(position = 0)vec3 pos;
out vec2 coord;
uniform sampler2D tex;
uniform vec2 pairs;
const int foo = 5;
const uvec2 range = uvec2(2, 5);

void main(){
    uint value = 2;
    value = range.x;
    value = range.y + fromRange.y;
    value = 4;
    
    float number = abs(pairs.a);
    number = sin(pairs.y);
    number = cos(fromPrevious.x);
    
    vec4 colors = texture(tex, pairs.xy);
    
    /*gl_Vertex
     gl_Normal
     gl_Color
     gl_MultiTexCoord0
     gl_MultiTexCoord1
     gl_MultiTexCoord2
     gl_MultiTexCoord3
     gl_MultiTexCoord4
     gl_MultiTexCoord5
     gl_MultiTexCoord6
     gl_MultiTexCoord7
     gl_FogCoord
     */
    coord = gl_Vertex.xy * 0.5 + 0.5;
    gl_Position = vec4(gl_Vertex.xyz, 1.0);

}



