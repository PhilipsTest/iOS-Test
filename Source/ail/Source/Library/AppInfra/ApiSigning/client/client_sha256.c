#include "client_sha256.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void enig_process(unsigned char *,unsigned char *,unsigned char *);

static unsigned int K[] = {
     0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
   0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
   0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
   0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
   0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
   0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
   0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
   0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
};



static void processRegularChunk(sha256_state_t state, unsigned int W[64]);

static unsigned int shiftr (int n , unsigned int x)
{
  return (x>>n);
}

static unsigned int rotr ( int n, unsigned int x)
{
  return (x >> n) | (x << (32-n));
}

static unsigned int s0 ( unsigned int W )
{
  return rotr(7,W) ^ rotr(18,W) ^ shiftr(3,W);
}

static unsigned int s1 ( unsigned int W )
{
  return rotr(17,W) ^ rotr(19,W) ^ shiftr(10,W);
}

static unsigned int S0 (unsigned int x)
{
  return rotr(2,x) ^ rotr(13,x) ^ rotr(22,x);
}

static unsigned int S1 (unsigned int x)
{
  return rotr(6,x) ^ rotr(11,x) ^ rotr(25,x);
}

static unsigned int Ch ( unsigned int x, unsigned int y, unsigned int z)
{
  return (x & y) ^ ((~x) & z);
}

static unsigned int Maj ( unsigned int x, unsigned int y, unsigned int z)
{
  return (x & y ) ^ ( x & z ) ^ ( y & z );
}

static unsigned char *convertI2C ( unsigned int *x , int x_len)
{ 
  unsigned char *result = malloc(x_len *4);
  for (int i = 0 ; i < x_len ; i ++)
    {
      unsigned int temp = x[i];
      for (int j = 0 ; j < 4; j ++)
        {
          result[(4*i)+j] = temp & 255;
          temp = temp >> 8;
        }
    }
  return result;

}

static unsigned int *convertC2I (unsigned char *x, int c_len)
{ 
  int size = (c_len+3)/4;

  unsigned int *result = malloc(size*sizeof(unsigned int));
  for (int i = 0 ; i < size; i ++)
    {
      unsigned int temp = 0;
      for (int j = 3; j >= 0; j --)
        {
          temp = (temp << 8) + x[(4*i)+j];
        }
      result[i] = temp;
    }
  return result;
}


static void processSpecialChunk2(sha256_state_t state, unsigned int W[64])
{
  unsigned char *my_H = convertI2C(state->H,8);
  unsigned char *my_W = convertI2C(W,64);
  unsigned char *my_K = convertI2C(K,64);

  
  enig_process(my_H,my_W,my_K);
  free(my_W);
  free(my_K);

  unsigned int *d_H = convertC2I(my_H,32);
  free(my_H);



  free(state->H);
  state->H = d_H;
  state->encrypted = 0;

}

static void processRegularChunk(sha256_state_t state, unsigned int W[64])
{
  unsigned int a = state->H[0];
  unsigned int b = state->H[1];
  unsigned int c = state->H[2];
  unsigned int d = state->H[3];
  unsigned int e = state->H[4];
  unsigned int f = state->H[5];
  unsigned int g = state->H[6];
  unsigned int h = state->H[7];

  for (int i = 0; i < 64; i ++)
    {

      unsigned int T1 = h + S1(e) + Ch(e,f,g) + K[i] + W[i];
      unsigned int T2 = S0(a) + Maj(a,b,c);
      h = g ;
      g = f;
      f = e;
      e = d + T1;
      d = c;
      c = b;
      b = a;
      a = T1 + T2;

      

    }


  state->H[0] = a + state->H[0];
  state->H[1] = b + state->H[1];
  state->H[2] = c + state->H[2];
  state->H[3] = d + state->H[3];
  state->H[4] = e + state->H[4];
  state->H[5] = f + state->H[5];
  state->H[6] = g + state->H[6];
  state->H[7] = h + state->H[7];



}


void processChunk(sha256_state_t state, unsigned char *data)
{
  unsigned int W[64];
  for (int i = 0 ; i < 16 ; i +=1)
    {
      W[i] = 0;
      for (int j = 0; j < 4; j ++)
        {
          W[i] = (W[i] << 8) | data[i*4+j];
        }
    }
  // compute the rest of W
  for (int i = 16; i < 64; i ++)
    {
      W[i] = s1(W[i-2]) + W[i-7] + s0(W[i-15]) + W[i-16];
    }
  
  if (state->encrypted)
    {
      processSpecialChunk2(state,W);
    }
  else
    {
      processRegularChunk(state,W);
    }
}


int init_sha256 (sha256_state_t *state )
{
  sha256_state_t result = malloc(sizeof(struct sha256_state_s));
  result->H = malloc(sizeof(unsigned char) * 32);
  result->buffer = malloc(sizeof(unsigned char) * 64);
  result->buffer_length = 0;
  result->processed_length = 0;
  
  result->H[0] = 0x6a09e667;
  result->H[1] = 0xbb67ae85;
  result->H[2] = 0x3c6ef372;
  result->H[3] = 0xa54ff53a;
  result->H[4] = 0x510e527f;
  result->H[5] = 0x9b05688c;
  result->H[6] = 0x1f83d9ab;
  result->H[7] = 0x5be0cd19;
  
  *state = result;
  return 0;
}

int process_sha256 ( sha256_state_t state, unsigned char *data , int length)
{
  int start = 0;
  if (state->buffer_length != 0)
    {
      // copy the first chunk into the buffer so it can be processed
      int l = (64 - state->buffer_length); 
      if (length < l) l = length;
      memcpy( (state->buffer)+(state->buffer_length),data,l);
      processChunk(state,state->buffer);
      state->processed_length = state->processed_length + 64;
      state->buffer_length = 0;
      start = l;
    }
  while (length - start >= 64)
    {
      processChunk(state,data + start);
      start = start + 64;
      state->processed_length = state->processed_length + 64;
    }
  if (length - start > 0)
    {
      state->buffer_length = length - start;
      memcpy(state->buffer,data+start,length-start);
    }
  return 0;
}


int finish_sha256 ( sha256_state_t state )
{
  // this is where the processing is required.
  // does the buffer have enough length to hold 8 bytes for length, and 1 
  // byte for 8. 

  int size = (state->processed_length + state->buffer_length)*8;

  if (state->buffer_length + 9 > 64)
    {


      // not enough room 64 more bytes required
      // buffer_length must be < 64. We can add the 0x80
      state->buffer[state->buffer_length] = 0x80;
      for (int i = state->buffer_length + 1; i< 64; i ++)
        {
          state->buffer[i] = 0;
        }

      processChunk(state,state->buffer);
      
      for (int i = 0 ; i < 56; i ++)
        {
          state->buffer[i] = 0;
        }
      for (int i = 7 ; i >=0; i --)
        {
          state->buffer[56+i] = size % 256;
          size = size/256;
        }
      processChunk(state,state->buffer);      
      return 0;
    }
  else
    { // we can fill the current buffer with the tail
      state->buffer[state->buffer_length] = 0x80;
      for (int i = state->buffer_length + 1; i < 56 ; i ++)
        state->buffer[i] = 0;

      for (int i = 7 ; i >=0; i --)
        {
          state->buffer[56+i] = size % 256;
          size = size/256;
        }
      processChunk(state,state->buffer);      
      return 0;
    }
}


int extract_data_sha256 ( sha256_state_t state, unsigned char **data, int *length)
{ 
  unsigned char *d = malloc(sizeof(unsigned char) * 32);
  *data = d;
  *length = 32;
  
  for (int i = 0 ; i < 8; i ++)
    {
      unsigned int temp = state->H[i];
      for (int j = 3 ; j >= 0; j --)
        {
          d[i*4 + j] = temp & 255;
          temp = temp >> 8;
        }
    }

  return 0;
}

void release_sha256 ( sha256_state_t state)
{
  free(state->H);
  free(state->buffer);
  free(state);
}



