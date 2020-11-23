#ifndef PS_HMAC_H
#define PS_HMAC_H


/** mey must be a 64 byte encrypted key that was generated by keygen.
    message is a byte-sequence
    message_len is the number of bytes in the message byte-sequence

    result must be able to hold 32 bytes.

    the function ps_hmac computes the hmac-sha256 signature of the message
    based on the encrypted key, and places the signature in the result
    array.
**/
    
    


int ps_hmac ( unsigned char *key, unsigned char *message, int message_len,
            unsigned char *result);

  




#endif
