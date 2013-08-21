//
//  Vectors.h
//  cube
//
//  Created by tzvifi on 7/4/13.
//
//

#ifndef cube_Vectors_h
#define cube_Vectors_h

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

/** A vector in 3D space. */
typedef struct {
	GLfloat x;			/**< The X-componenent of the vector. */
	GLfloat y;			/**< The Y-componenent of the vector. */
	GLfloat z;			/**< The Z-componenent of the vector. */
} CC3Vector;

typedef struct {
	GLfloat x;			/**< The X-componenent of the vector. */
	GLfloat y;			/**< The Y-componenent of the vector. */
	GLfloat z;			/**< The Z-componenent of the vector. */
	GLfloat w;			/**< The homogeneous ratio factor. */
} CC3Vector4;

CC3Vector CC3VectorNormalize(CC3Vector v);
CC3Vector CC3VectorCross(CC3Vector v1, CC3Vector v2);
#endif
    