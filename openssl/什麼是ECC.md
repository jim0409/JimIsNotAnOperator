# intro
So far, major ke algorithms, RSA and DSA, have experienced a wide application in the Internet security field.

And after more than 30 years of success modern ECDSA(Elliptic Curve Digital Signature Algorithm) keys come on the stage


# DSA(Digital Signature Algorithm)
An algorithm for digital signaure generation with the means of Private/Public Keys pair.

The signaure is created secretly but can be identified publicly.

This means that only one subject can actually create the signature of the message using the Private Key, 

but anyone can verify its adequacy having a corresponding Public Key.

This algorithm has been offered by the `National Institute of Standards and Technology(NIST)` back in August 1991 and proclaimed along

with SHA-1 hash function as a part of DSS(Digital Signature Standard) in 1994


# RSA(Abbreviation of scientist's last names `Ron Rivest, AdiShamir, and Leonard Adleman)
Apart from DSA, has become the first cryptosystem applicable for digital signature and data encrypting, even though the idea has

been first exposed to light in 1978. RSA algorithm implies three main steps: key pair generation, encryption and decryption.

A public key is transmitted over an open channel, while the Private Key remains secret. The data, which is encrypted with the Private Key,

can only be decrypted with the Public Key, which is mathematically linked to a Private one.

RSA can be used to determine the data source origin.


# ECDSA(Elliptic Curve Digital Signature Algorithm)
Which is just a mathematical equation on its own.

ECDSA is the algorithm, that makes Elliptic Curve Cryptography useful for security.

Neal Koblitz and Victor S. Miller independently suggested the use of elliptic curves in cryptography in 1985,

and a wide performance was gained in 2004 and 2005.

It differs from DSA due to that fact that it is applicable not over the whole numbers of a finite field

but to certain points of elliptic curve to define Public/Private Keys pair


# ECC certificates: pros and cons
Being a golden standard by far, RSA key algorithm is the one, which is most widely used in the digital security.

However, according to the modern tendency of using mobile and compact devices, ‘pure web performance’ stands up at the head of the whole business.

From this perspective the physical size of the key is a predominant question.

DSA and RSA key algorithms require a larger key size and could be defeated by factoring a large number.

When it comes to ECDSA, the Elliptic Curve Discrete Logarithm Problem (ECDLP) needs to be solved in order to break the key,

and there was no major progress so far to achieve this.

`Thus ECC certificate provides a better security solution` and is more difficult to break using usual hacker’s ‘brute force’ methods.

`Shorter key size` is definitely among the advantages as well. In the table below we compared RSA and ECDSA Key sizes for a better layout.




# refer:
- https://www.ztabox.com/knowledgebase_article.php?id=131
