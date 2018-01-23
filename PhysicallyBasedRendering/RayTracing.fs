#version 440 core

uniform mat4 view;

const float pi = 3.141592653;

in vec2 outUV;

uniform vec3 lightPos;

out vec3 color;

// Tracing and intersection
///////////////////////////
struct Ray
{
    vec3 origin;
    vec3 dir;
};

struct Rect
{
    vec3  center;
    vec3  dirx;
    vec3  diry;
    float halfx;
    float halfy;

    vec4  plane;
};

struct Sphere
{
	vec3 origin;
	float radius;
};

bool RayPlaneIntersect(Ray ray, vec4 plane, out float t)
{
    t = -dot(plane, vec4(ray.origin, 1.0))/dot(plane.xyz, ray.dir);
    return t > 0.0;
}

bool RayRectIntersect(Ray ray, Rect rect, out float t)
{
    bool intersect = RayPlaneIntersect(ray, rect.plane, t);
    if (intersect)
    {
        vec3 pos  = ray.origin + ray.dir*t;
        vec3 lpos = pos - rect.center;
        
        float x = dot(lpos, rect.dirx);
        float y = dot(lpos, rect.diry);    

        if (abs(x) > rect.halfx || abs(y) > rect.halfy)
            intersect = false;
    }

    return intersect;
}

bool RaySphereIntersect(Ray ray, Sphere sphere, out float t)
{
	vec3 s = ray.origin - sphere.origin;

	float a = dot(ray.dir, ray.dir);
	float bPrime = dot(s, ray.dir);
	float c = dot(s, s) - sphere.radius * sphere.radius;

	float D = bPrime * bPrime - a * c;
	if(D >= 0 && bPrime <= 0)
	{
		float t1 = (-bPrime + sqrt(D)) / a;
		float t2 = (-bPrime + sqrt(D)) / a;
		t = t1 > t2 ? t2 : t1;
		return true;
	}
	else 
		return false;
}

// Camera functions
///////////////////
Ray GenerateCameraRay()
{
	Ray ray;
	// -1 ~ 1
	float x = (outUV.x - 0.5) * 2.0;
	float y = (outUV.y - 0.5) * 2.0;
	ray.dir = normalize(vec3(x, y, -1.0));

	ray.origin = vec3(0.0);

	ray.origin = (-view*vec4(vec3(0.0), 1)).xyz;
    ray.dir    = normalize((view*vec4(ray.dir, 0)).xyz);

	return ray;
}

vec3 mul(mat3 m, vec3 v)
{
    return m * v;
}

mat3 mul(mat3 m1, mat3 m2)
{
    return m1 * m2;
}

vec3 rotation_y(vec3 v, float a)
{
    vec3 r;
    r.x =  v.x*cos(a) + v.z*sin(a);
    r.y =  v.y;
    r.z = -v.x*sin(a) + v.z*cos(a);
    return r;
}

vec3 rotation_z(vec3 v, float a)
{
    vec3 r;
    r.x =  v.x*cos(a) - v.y*sin(a);
    r.y =  v.x*sin(a) + v.y*cos(a);
    r.z =  v.z;
    return r;
}

vec3 rotation_yz(vec3 v, float ay, float az)
{
    return rotation_z(rotation_y(v, ay), az);
}

mat3 transpose(mat3 v)
{
    mat3 tmp;
    tmp[0] = vec3(v[0].x, v[1].x, v[2].x);
    tmp[1] = vec3(v[0].y, v[1].y, v[2].y);
    tmp[2] = vec3(v[0].z, v[1].z, v[2].z);

    return tmp;
}

// Misc. helpers
////////////////
float saturate(float v)
{
    return clamp(v, 0.0, 1.0);
}

vec3 PowVec3(vec3 v, float p)
{
    return vec3(pow(v.x, p), pow(v.y, p), pow(v.z, p));
}

const float gamma = 2.2;

vec3 ToLinear(vec3 v) { return PowVec3(v,     gamma); }
vec3 ToSRGB(vec3 v)   { return PowVec3(v, 1.0/gamma); }

void main()
{
    vec4 floorPlane = vec4(0, 1, 0, 0);
	Sphere sphere;
	sphere.origin = vec3(0.0, 0.0, -10.0);
	sphere.radius = 1.0f;

	// output color
    vec3 col = vec3(0.1, 0.2, 0.4);

    Ray ray = GenerateCameraRay();

    float distToFloor, distToSphere;
    bool hitFloor = RayPlaneIntersect(ray, floorPlane, distToFloor);
	bool hitSphere = RaySphereIntersect(ray, sphere, distToSphere);
	// floor의 색을 칠해야 함
    if(hitFloor)
    {
        vec3 hitPoint = ray.origin + ray.dir*distToFloor;

        vec3 N = floorPlane.xyz;
        vec3 V = -ray.dir;
        
        float theta = acos(dot(N, V));
        
		col = vec3(0.2, 0.1, 0.1);

		vec3 S = normalize(lightPos - hitPoint);
		Ray SRay;
		SRay.origin = hitPoint;
		SRay.dir = S;
		float tmpDist;
		// TODO
		if(RaySphereIntersect(SRay, sphere, tmpDist))
			col = vec3(0.0, 0.0, 0.0);
		else
			col = vec3(1.0, 0.0, 0.0);
    }

	if(hitFloor)
		col = vec3(1.0, 1.0, 0.5);

	if(hitSphere)
	{
		vec3 hitPoint = ray.origin + ray.dir * distToSphere;
		vec3 L = normalize(lightPos - hitPoint);
		vec3 N = normalize(hitPoint - sphere.origin);

		vec3 ambient = vec3(0.2, 0.2, 0.2);

		vec3 diffuse = vec3(0.1, 0.4, 0.2) * max(0, dot(N, L));

		vec3 V = -ray.dir;

		vec3 specular = vec3(0.1, 0.4, 0.2) * max(0, pow(dot(normalize(reflect(L, N)), V), 16));

		col = ambient + diffuse + specular;
	}

    color = col;
}