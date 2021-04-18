The design contains a FP16 multiplier with Prep, Execute, Normalize and Round modules. The floating point format used is a simplified IEEE754 half precision standard and supports the default IEEE754 rounding mode (round to nearest, tie to even) and all the exception flags. Signalling NaNs are not supported, neither are denormalized numbers. The design is a single cycle implementation. The design is a 4 stage pipeline.