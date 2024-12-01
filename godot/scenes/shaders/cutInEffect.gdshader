shader_type canvas_item;
render_mode blend_mix;

uniform float DEBUGID: hint_range(0, 9) = 1.;
uniform float CutInValue: hint_range(0.0, 1.0) = 1.0;
uniform float CutOutValue: hint_range(0.0, 1.0) = 0.0;
uniform float OffsetValue: hint_range(0.0, 0.2) = 0.1;
uniform float UVOffsetValue: hint_range(0.0, 1.0) = 0.1;
uniform vec2 TPoint1Start = vec2(1.215, 0.065);
uniform vec2 TPoint2Start = vec2(1.035, 0.49);
uniform vec2 TPoint3Start = vec2(-0.08, 0.575);
uniform vec2 TPoint1End = vec2(1.215, 0.065);
uniform vec2 TPoint2End = vec2(1.035, 0.49);
uniform vec2 TPoint3End = vec2(-0.08, 0.575);
uniform vec2 TPoint1Out = vec2(1.215, 0.065);
uniform vec2 TPoint2Out = vec2(1.035, 0.49);
uniform vec2 TPoint3Out = vec2(-0.08, 0.575);

//const vec2 PPoint1 = vec2(0.0, 0.0);
//const vec2 PPoint2 = vec2(0.0, 0.0);
//const vec2 PPoint3 = vec2(0.0, 0.0);
//const vec2 PPoint4 = vec2(0.0, 0.0);

uniform vec3 Blue = vec3(0.,0.,1.);
uniform vec3 Red = vec3(.6,0.,0.);
uniform vec3 Teal = vec3(.0,.4,.4);
uniform vec4 BlueBackground = vec4(0.,0.,.7,.7);
uniform vec4 RedBackground = vec4(.7,0.,0.,.7);
uniform vec4 TealBackground = vec4(0.,.4,.5,.7);


uniform vec3 OutlineColor = vec3(0.,0.,1.);
uniform vec4 BackgroundColor = vec4(0.,0.,.7,.7);

const int N = 4;

uniform vec2 polygon[4];
//const int[1] _test = {int[](0, 1, 2, 3)};
//const vec2[1] polygon = {vec2[](PPoint1,PPoint2,PPoint3,PPoint4)};

float sdTriangle( in vec2 p, in vec2 p0, in vec2 p1, in vec2 p2 )
{
    vec2 e0 = p1-p0, e1 = p2-p1, e2 = p0-p2;
    vec2 v0 = p -p0, v1 = p -p1, v2 = p -p2;
    vec2 pq0 = v0 - e0*clamp( dot(v0,e0)/dot(e0,e0), 0.0, 1.0 );
    vec2 pq1 = v1 - e1*clamp( dot(v1,e1)/dot(e1,e1), 0.0, 1.0 );
    vec2 pq2 = v2 - e2*clamp( dot(v2,e2)/dot(e2,e2), 0.0, 1.0 );
    float s = sign( e0.x*e2.y - e0.y*e2.x );
    vec2 d = min(min(vec2(dot(pq0,pq0), s*(v0.x*e0.y-v0.y*e0.x)),
                     vec2(dot(pq1,pq1), s*(v1.x*e1.y-v1.y*e1.x))),
                     vec2(dot(pq2,pq2), s*(v2.x*e2.y-v2.y*e2.x)));
    return -sqrt(d.x)*sign(d.y);
}

float sdPolygon( in vec2[N] v, in vec2 p )
{
    float d = dot(p-v[0],p-v[0]);
    float s = 1.0;
    for( int i=0, j=N-1; i<N; j=i, i++ )
    {
        vec2 e = v[j] - v[i];
        vec2 w =    p - v[i];
        vec2 b = w - e*clamp( dot(w,e)/dot(e,e), 0.0, 1.0 );
        d = min( d, dot(b,b) );
        bvec3 c = bvec3(p.y>=v[i].y,p.y<v[j].y,e.x*w.y>e.y*w.x);
        if( all(c) || all(not(c)) ) s*=-1.0;  
    }
    return s*sqrt(d);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float TimeValue = TIME;
	vec2 ps = SCREEN_PIXEL_SIZE;
	
	
	
	vec2 CustomUV = UV - vec2(0.0,UVOffsetValue);
	
	vec4 Texture = texture(TEXTURE, CustomUV);
	vec4 finalColor = vec4(1,0,0,1);
	float TimeDivide = float(360);
	
	
	//float TimeCalc = sin(TIME) * 0.5 + 0.5;
	float TimeCalc = (sin(TIME*2.) + 5.0) / 60.0;
	
	float OffsetCalc = OffsetValue * TimeCalc;
	
	vec4 TextureOffsetRight = texture(TEXTURE, CustomUV - vec2(OffsetCalc, 0));
	vec4 TextureOffsetLeft = texture(TEXTURE, CustomUV + vec2(OffsetCalc, 0));
	
	
	vec2 TPoint1Slide = mix(TPoint1Start, mix(TPoint1End ,TPoint1Out, CutOutValue), CutInValue);
	vec2 TPoint2Slide = mix(TPoint2Start, mix(TPoint2End ,TPoint2Out, CutOutValue), CutInValue);
	vec2 TPoint3Slide = mix(TPoint3Start, mix(TPoint3End ,TPoint3Out, CutOutValue), CutInValue);
	
	
	vec4 BackgroundWhite = vec4(1.,1.,1.,floor(1.0 - sdPolygon(polygon, UV)));
	float RenderMaskTriangle = floor(1.0 - sdTriangle(UV, TPoint1Slide, TPoint2Slide, TPoint3Slide));
	
	vec4 BlueMiku = mix(TextureOffsetLeft, vec4(OutlineColor,TextureOffsetLeft.a), 1);
	vec4 GrayMiku = mix(TextureOffsetRight, vec4(0.3,0.3,0.3,TextureOffsetRight.a), 1);
	vec4 OutlineMiku = mix(BlueMiku, GrayMiku, GrayMiku.w);
	vec4 FinalMiku = mix(OutlineMiku, Texture, Texture.w);
	vec4 BlackMiku = mix(FinalMiku, vec4(0.,0.,0.,ceil(FinalMiku.w)), 1);
	vec4 MikuComp = mix(BlackMiku, FinalMiku, BackgroundWhite.w);
	vec4 BackgroundComp = mix(BackgroundWhite, MikuComp, MikuComp.w);
	vec4 FinalComp = mix(BackgroundColor, BackgroundComp, BackgroundComp.w);
	vec4 FinalMask = vec4(FinalComp.rgb, FinalComp.w * RenderMaskTriangle);
	
	vec4 DEBUGLAYERS =	mix(BlueMiku, 
						mix(GrayMiku, 
						mix(OutlineMiku, 
						mix(FinalMiku, 
						mix(BlackMiku,
						mix(MikuComp,
						mix(BackgroundComp,
						mix(FinalComp,
						FinalMask,
						clamp(floor(DEBUGID/8.),0.,1.)), 
						clamp(floor(DEBUGID/7.),0.,1.)), 
						clamp(floor(DEBUGID/6.),0.,1.)), 
						clamp(floor(DEBUGID/5.),0.,1.)), 
						clamp(floor(DEBUGID/4.),0.,1.)), 
						clamp(floor(DEBUGID/3.),0.,1.)), 
						clamp(floor(DEBUGID/2.),0.,1.)), 
						clamp(floor(DEBUGID),0.,1.));

	
	//finalColor = mix(Texture, vec4(TimeCalc,TimeCalc,TimeCalc,Texture.w), blendValue);
	//finalColor = mix(Texture, sphereCutout, float(1)-Texture.w);
	//finalColor.r = (TEXTURE_PIXEL_SIZE.r * float(500));
	
	finalColor = DEBUGLAYERS;
	//finalColor =  FinalComp;
	
	COLOR = finalColor;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
