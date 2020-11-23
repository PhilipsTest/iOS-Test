#include "ps_hmac.h"
#include "client_sha256.h"

int ps_hmac ( unsigned char *key, unsigned char *message, int message_len,
            unsigned char *result)
{

  // Setup inner and outer H state. Convert unsigned char sequence
  // to unsigned int sequence
  sha256_state_t inner;
  init_sha256(&inner);
  inner->encrypted = 1;
  
  for (int i = 0; i < 8; i ++)
    {
      unsigned int temp = 0;
      for (int j = 0 ; j < 4; j ++)
        {
          temp = (temp << 8) | key[4*i + j];
        }
      inner->H[i] = temp;
    }
  inner->processed_length=64;

  sha256_state_t outer;
  init_sha256(&outer);
  outer->encrypted = 1;
  for (int i = 0; i < 8; i ++)
    {
      unsigned int temp = 0;
      for (int j = 0 ; j < 4; j ++)
        {
          temp = (temp << 8) | key[32+(4*i) + j];
        }
      outer->H[i] = temp;
    }
  outer->processed_length=64;
  
  process_sha256(inner,message,message_len);
  finish_sha256(inner);


  unsigned char *iresult;
  int iresult_len;
  extract_data_sha256(inner,&iresult,&iresult_len);
  
  process_sha256(outer,iresult,iresult_len);
  finish_sha256(outer);
  
  extract_data_sha256(outer,&iresult,&iresult_len);
  for (int i = 0; i < 32; i ++) result[i] = iresult[i];

  return 0;
}
