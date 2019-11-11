pragma solidity ^0.5.6;

import { Pairing } from "./Pairing.sol";

contract Verifier {
          using Pairing for *;
          struct VerifyingKey {
              Pairing.G2Point A;
              Pairing.G1Point B;
              Pairing.G2Point C;
              Pairing.G2Point gamma;
              Pairing.G1Point gammaBeta1;
              Pairing.G2Point gammaBeta2;
              Pairing.G2Point Z;
              Pairing.G1Point[] IC;
          }
          struct Proof {
              Pairing.G1Point A;
              Pairing.G1Point A_p;
              Pairing.G2Point B;
              Pairing.G1Point B_p;
              Pairing.G1Point C;
              Pairing.G1Point C_p;
              Pairing.G1Point K;
              Pairing.G1Point H;
          }
          function verifyingKey() pure internal returns (VerifyingKey memory vk);
          function verify(uint[] memory input, Proof memory proof) view internal returns (uint);
          function verifyProof(
                  uint[2] memory a,
                  uint[2] memory a_p,
                  uint[2][2] memory b,
                  uint[2] memory b_p,
                  uint[2] memory c,
                  uint[2] memory c_p,
                  uint[2] memory h,
                  uint[2] memory k,
                  uint[1] memory input
              ) view public returns (bool r); 
      }