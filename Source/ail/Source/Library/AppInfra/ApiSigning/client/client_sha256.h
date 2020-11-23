#ifndef CLIENT_SHA256_H
#define CLIENT_SHA256_H


struct sha256_state_s
{
  unsigned int *H;
  unsigned char *buffer; // buffer is less than 16 words 
  int processed_length;
  int buffer_length;
  int encrypted;
};

typedef struct sha256_state_s *sha256_state_t;


/** all functions below return 0 on success, otherwise on failure */

int init_sha256 (sha256_state_t *state);


int process_sha256 ( sha256_state_t state, unsigned char *data , int length);
int finish_sha256 ( sha256_state_t state );
int extract_data_sha256 ( sha256_state_t state, unsigned char **data, int *length);
void release_sha256 ( sha256_state_t state);


#endif





