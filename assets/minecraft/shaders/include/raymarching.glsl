
float sdSphere(vec3 p,float s) {
    return length(p) -s;
}

float sdBox(vec3 p,vec3 b) {
    vec3 q = abs(p) - b;
    return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float smin(float a, float b, float k) {
    float h = max(k - abs(a-b),0.0)/k;
    return min(a,b) - h*h*h*k*(1.0/6.0);
}

mat2 rot2D(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c,-s,s,c);
} 
 
///////////////////////
// Primitives
///////////////////////
 
// Dot2 helper function
float dot2( vec2 v ) { return dot(v,v); }
float dot2( vec3 v ) { return dot(v,v); }
 
// Sphere - exact
float sphereSDF( vec3 p, float s ) {
  return length(p)-s;
}
 
// Box - exact 
float boxSDF( vec3 p, vec3 b ) {
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}
 
// Round Box - exact
float roundBoxSDF( vec3 p, vec3 b, float r ) {
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0) - r;
}
 
// Plane - exact
float planeSDF( vec3 p, vec4 n ) {
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}
 
// Hexagonal Prism - exact
float hexPrismSDF(vec3 p, vec2 h) {
  const vec3 k = vec3(-0.8660254, 0.5, 0.57735);
  p = abs(p);
  p.xy -= 2.0*min(dot(k.xy, p.xy), 0.0)*k.xy;
  vec2 d = vec2(
       length(p.xy-vec2(clamp(p.x,-k.z*h.x,k.z*h.x), h.x))*sign(p.y-h.x),
       p.z-h.y );
  return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}
 
// Triangular Prism - exact
float triPrismSDF( vec3 p, vec2 h ) {
    const float k = sqrt(3.0);
    h.x *= 0.5*k;
    p.xy /= h.x;
    p.x = abs(p.x) - 1.0;
    p.y = p.y + 1.0/k;
    if( p.x+k*p.y>0.0 ) p.xy=vec2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0, 0.0 );
    float d1 = length(p.xy)*sign(-p.y)*h.x;
    float d2 = abs(p.z)-h.y;
    return length(max(vec2(d1,d2),0.0)) + min(max(d1,d2), 0.);
}
 
//Capsule / Line
float capsuleSDF( vec3 p, vec3 a, vec3 b, float r ) {
  vec3 pa = p - a, ba = b - a;
  float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
  return length( pa - ba*h ) - r;
}
 
//Capsule / Line - exact
float verticalCapsuleSDF(vec3 p, float h, float r) {
  p.y -= clamp( p.y, 0.0, h );
  return length( p ) - r;
}
 
//Ininite Cylinder - exact
float cylinderSDF( vec3 p, vec3 c ) {
  return length(p.xz-c.xy)-c.z;
}
 
//Capped Cylinder - exact
float cappedCylinderSDF( vec3 p, float h, float r ) {
  vec2 d = abs(vec2(length(p.xz),p.y)) - vec2(h,r);
  return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}
 
//Capped Cylinder - exact
float cappedCylinderSDF(vec3 p, vec3 a, vec3 b, float r) {
  vec3  ba = b - a;
  vec3  pa = p - a;
  float baba = dot(ba,ba);
  float paba = dot(pa,ba);
  float x = length(pa*baba-ba*paba) - r*baba;
  float y = abs(paba-baba*0.5)-baba*0.5;
  float x2 = x*x;
  float y2 = y*y*baba;
  float d = (max(x,y)<0.0)?-min(x2,y2):(((x>0.0)?x2:0.0)+((y>0.0)?y2:0.0));
  return sign(d)*sqrt(abs(d))/baba;
}
 
// Rounded Cylinder - exact
float roundedCylinderSDF( vec3 p, float ra, float rb, float h ) {
  vec2 d = vec2( length(p.xz)-2.0*ra+rb, abs(p.y) - h );
  return min(max(d.x,d.y),0.0) + length(max(d,0.0)) - rb;
}
 
// Cone - exact
float coneSDF( vec3 p, vec2 c ) {
  // c is the sin/cos of the angle
  float q = length(p.xy);
  return dot(c,vec2(q,p.z));
}
 
// Capped Cone - exact
//float dot2( vec3 v ) { return dot(v,v); }
float cappedConeSDF( vec3 p, float h, float r1, float r2 ) {
  vec2 q = vec2( length(p.xz), p.y );
  vec2 k1 = vec2(r2,h);
  vec2 k2 = vec2(r2-r1,2.0*h);
  vec2 ca = vec2(q.x-min(q.x,(q.y<0.0)?r1:r2), abs(q.y)-h);
  vec2 cb = q - k1 + k2*clamp( dot(k1-q,k2)/dot2(k2), 0.0, 1.0 );
  float s = (cb.x<0.0 && ca.y<0.0) ? -1.0 : 1.0;
  return s*sqrt( min(dot2(ca),dot2(cb)) );
}
 
// Capped Cone - exact
float cappedConeSDF(vec3 p, vec3 a, vec3 b, float ra, float rb) {
  float rba  = rb-ra;
  float baba = dot(b-a,b-a);
  float papa = dot(p-a,p-a);
  float paba = dot(p-a,b-a)/baba;
  float x = sqrt( papa - paba*paba*baba );
  float cax = max(0.0,x-((paba<0.5)?ra:rb));
  float cay = abs(paba-0.5)-0.5;
  float k = rba*rba + baba;
  float f = clamp( (rba*(x-ra)+paba*baba)/k, 0.0, 1.0 );
  float cbx = x-ra - f*rba;
  float cby = paba - f;
  float s = (cbx<0.0 && cay<0.0) ? -1.0 : 1.0;
  return s*sqrt( min(cax*cax+cay*cay*baba, cbx*cbx+cby*cby*baba) );
}
 
// Solid Angle - exact
float solidAngleSDF(vec3 p, vec2 c, float ra) {
  // c is the sin/cos of the angle
  vec2 q = vec2( length(p.xz), p.y );
  float l = length(q) - ra;
  float m = length(q - c*clamp(dot(q,c),0.0,ra) );
  return max(l,m*sign(c.y*q.x-c.x*q.y));
}
 
// Round cone - exact
float roundConeSDF( vec3 p, float r1, float r2, float h ) {
  vec2 q = vec2( length(p.xz), p.y );
     
  float b = (r1-r2)/h;
  float a = sqrt(1.0-b*b);
  float k = dot(q,vec2(-b,a));
     
  if( k < 0.0 ) return length(q) - r1;
  if( k > a*h ) return length(q-vec2(0.0,h)) - r2;
         
  return dot(q, vec2(a,b) ) - r1;
}
 
// Ellipsoid - bound (not exact!)
float ellipsoidSDF( vec3 p, vec3 r ) {
  float k0 = length(p/r);
  float k1 = length(p/(r*r));
  return k0*(k0-1.0)/k1;
}
 
// Torus - exact 
float torusSDF( vec3 p, vec2 t ) {
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}
 
// Capped Torus - exact 
float cappedTorusSDF(in vec3 p, in vec2 sc, in float ra, in float rb) {
  p.x = abs(p.x);
  float k = (sc.y*p.x>sc.x*p.y) ? dot(p.xy,sc) : length(p.xy);
  return sqrt( dot(p,p) + ra*ra - 2.0*ra*k ) - rb;
}
 
// Joint - exact
// returns distance in .x and UVW parametrization in .yzw
vec4 joint3DSphereSDF( in vec3 p, in float l, in float a, in float w) {
  if( abs(a)<0.001 ) return vec4( length(p-vec3(0,clamp(p.y,0.0,l),0))-w, p );
     
  vec2  sc = vec2(sin(a),cos(a));
  float ra = 0.5*l/a;
  p.x -= ra;
  vec2 q = p.xy - 2.0*sc*max(0.0,dot(sc,p.xy));
  float u = abs(ra)-length(q);
  float d2 = (q.y<0.0) ? dot2( q+vec2(ra,0.0) ) : u*u;
  float s = sign(a);
  return vec4( sqrt(d2+p.z*p.z)-w,
               (p.y>0.0) ? s*u : s*sign(-p.x)*(q.x+ra),
               (p.y>0.0) ? atan(s*p.y,-s*p.x)*ra : (s*p.x<0.0)?p.y:l-p.y,
               p.z );
}
 
// Link - exact
float linkSDF(vec3 p, float le, float r1, float r2) {
  vec3 q = vec3( p.x, max(abs(p.y)-le,0.0), p.z );
  return length(vec2(length(q.xy)-r1,q.z)) - r2;
}
 
// Octahedron - exact
float octahedronSDF(vec3 p, float s) {
  p = abs(p);
  float m = p.x+p.y+p.z-s;
  vec3 q;
       if( 3.0*p.x < m ) q = p.xyz;
  else if( 3.0*p.y < m ) q = p.yzx;
  else if( 3.0*p.z < m ) q = p.zxy;
  else return m*0.57735027;
     
  float k = clamp(0.5*(q.z-q.y+s),0.0,s); 
  return length(vec3(q.x,q.y-s+k,q.z-k)); 
}
 
// Octahedron - bound (not exact)
float octahedron2SDF(vec3 p, float s) {
  p = abs(p);
  return (p.x+p.y+p.z-s)*0.57735027;
}
 
// Pyramid - exact
float pyramidSDF(vec3 p, float h) {
  float m2 = h*h + 0.25;
     
  p.xz = abs(p.xz);
  p.xz = (p.z>p.x) ? p.zx : p.xz;
  p.xz -= 0.5;
 
  vec3 q = vec3( p.z, h*p.y - 0.5*p.x, h*p.x + 0.5*p.y);
    
  float s = max(-q.x,0.0);
  float t = clamp( (q.y-0.5*p.z)/(m2+0.25), 0.0, 1.0 );
     
  float a = m2*(q.x+s)*(q.x+s) + q.y*q.y;
  float b = m2*(q.x+0.5*t)*(q.x+0.5*t) + (q.y-m2*t)*(q.y-m2*t);
     
  float d2 = min(q.y,-q.x*m2-q.y*0.5) > 0.0 ? 0.0 : min(a,b);
     
  return sqrt( (d2+q.z*q.z)/m2 ) * sign(max(q.z,-p.y));
}
 
// Triangle UDF - exact 
float triangleUDF( vec3 p, vec3 a, vec3 b, vec3 c ) {
  vec3 ba = b - a; vec3 pa = p - a;
  vec3 cb = c - b; vec3 pb = p - b;
  vec3 ac = a - c; vec3 pc = p - c;
  vec3 nor = cross( ba, ac );
 
  return sqrt(
    (sign(dot(cross(ba,nor),pa)) +
     sign(dot(cross(cb,nor),pb)) +
     sign(dot(cross(ac,nor),pc))<2.0)
     ?
     min( min(
     dot2(ba*clamp(dot(ba,pa)/dot2(ba),0.0,1.0)-pa),
     dot2(cb*clamp(dot(cb,pb)/dot2(cb),0.0,1.0)-pb) ),
     dot2(ac*clamp(dot(ac,pc)/dot2(ac),0.0,1.0)-pc) )
     :
     dot(nor,pa)*dot(nor,pa)/dot2(nor) );
}
 
// Quad UDF - exact
float quadUDF( vec3 p, vec3 a, vec3 b, vec3 c, vec3 d) {
  vec3 ba = b - a; vec3 pa = p - a;
  vec3 cb = c - b; vec3 pb = p - b;
  vec3 dc = d - c; vec3 pc = p - c;
  vec3 ad = a - d; vec3 pd = p - d;
  vec3 nor = cross( ba, ad );
 
  return sqrt(
    (sign(dot(cross(ba,nor),pa)) +
     sign(dot(cross(cb,nor),pb)) +
     sign(dot(cross(dc,nor),pc)) +
     sign(dot(cross(ad,nor),pd))<3.0)
     ?
     min( min( min(
     dot2(ba*clamp(dot(ba,pa)/dot2(ba),0.0,1.0)-pa),
     dot2(cb*clamp(dot(cb,pb)/dot2(cb),0.0,1.0)-pb) ),
     dot2(dc*clamp(dot(dc,pc)/dot2(dc),0.0,1.0)-pc) ),
     dot2(ad*clamp(dot(ad,pd)/dot2(ad),0.0,1.0)-pd) )
     :
     dot(nor,pa)*dot(nor,pa)/dot2(nor) );
}
//////////////////////