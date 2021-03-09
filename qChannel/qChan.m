(* ::Package:: *)
(*

	Quantum Channel Programs in Mathematica.  
    Date: 09 Mar'21
	
    File header contains abbreviations and alphabetical list of all objects.
	Main file contains definitions of objects


 ABBREVIATIONS
 ALPHABETICAL LIST OF OBJECTS
    
    #Short Description
 chanMatToSuperOp   : Converts channel matrix to channel superoperator
 chanPair           : Gives pair of outputs from channel isometry
 choiToKraus        : Converts Choi matrix to Kraus operators
 choiToOp           : Converts Choi Matrix to channel superoperator
 krausComp          : Returns Kraus operators for the complementary channel
 krausToChanKet     : Converts Kraus operators channel ket
 krausToChanMat     : Converts Kraus operators to channel matrix
 krausToChanTen     : Converts Kraus operators to a four tensor
 krausToChoi        : Converts list of Kraus operators to a Choi matrix
 opToChoi           : Converts operator matrix to Choi matrix
 randChanIso        : Gives a random channel isometry
 randIso            : Generates a random isometry
 

Developer Notes
1.  Unintended feature: Loading the current pacakge automatically loads qinf050'
    into $Package. All functions in that package become available with the
    prefex qing050`
*)

BeginPackage["qChan`"]

chanMatToSuperOp::usage = "Takes a channel matrix M, channel input dimension d_In, and output dimension d_Out. Returns a four tensor representing channel superoperator. The first two tensor indices run from 1 to d_Out and last two from 1 to d_In.";

chanPair::usage = "Takes as input a square matrix of dimension da, an integer db representing the dimension of the channel output b, and an isometry taking the input space a -> b x c. Returns a pair of operators {rhoB,rhoC}, where rhoB is the channel output and rhoC is environment output";

choiToOp::usage="Takes a Choi Matrix and dimensions dIn, dOut of the channel input H_In and channel output H_Out. Returns the channel superoperator matrix: H_In^2 ->H_Out^2, where H_In^2 is a tensor product of H_In with itself. Assumes that theChoi matrix defined on the H_In x H_Out space. For reasoning. More details in documentation pdf";

choiToKraus::usage ="Takes a Choi matrix C, channel input dimension d_In, and output dimension d_Out. Returns a list of d = d_Out*d_In Kraus operators taking channel input H_In to output H_Out. Assumes (1) C is positive semi-definite of with dimension d = d_Out*d_In; (2) C is defined on the H_Out x H_In space; (3) C has trace d_In. See Documentation for details";

krausComp::usage = "Takes list of Kraus operators for the direct channel argument and returns list of Kraus operators for the complementary channel. More details in documentation pdf";

krausToChanKet::usage = "Takes list of Kraus operators for the a -> b channel. Returns a ket on H_c x H_b x H_a space where H_c is the channel environment. More details in the documentation";

krausToChanMat::usage = "Takes list of Kraus operators for the a-> b channel. Returns a matrix d_b^2 x d_a^2 matrix representing the channel superoperator. See documentation for details";

krausToChanTen::usage = "Takes list of Kraus operators for the a-> b channel. Returns a 4 tensor representing the channel. See Documentation for details";

krausToChoi::usage = "Takes list of channel Kraus operators, returns Choi matrix. More details in documentation";

opToChoi::usage = "Takes a channel matrix, and dimensions dIn, dOut of the channel input H_In and channel output H_Out. Returns the corresponding Choi matrix on the H_Out x H_In space . More details in documentation pdf";

randChanIso::usage = "Takes as input a channel input dimension da and returns an isometry with from channel input to channel output tensored with channel environment. By default channel output dimension dB is the same as channel input dA and channel environment dimension dC =  da*dB. These defaults dB and dC can be set by specifying the second and third arguments of this randChanIso function. For example randChanIso[2,3,4] generates an isometry with channel input dimension 2, output dimension 3, and environment dimension 4, i.e. an 12 x 2 complex matrix M with ConjugateTranspose[M].M = I_2";

randIso::usage = "Takes as input two integer dI <= dO and returns a random dO x dI dimensional complex valued matrix M which represents an isometry from input space of dimension dI to output space of dimension dO i.e. ConjugateTranspose[M].M = IdentityMatrix[dI]. When dI = dO, randIso returns a Haar Random Unitary";

Begin["`Private`"]
    (*Bult on top of qinf050.ma from http://quantum.phys.cmu.edu/QPM/*)
    
    (*Needs["qinf050`",]
    SetDirectory[NotebookDirectory[]]
    *)
    AppendTo[$Path, Directory[]]
    << qinf050`

    chanMatToSuperOp[mat_, dIn_, dOut_] := ket2kten[Flatten[mat], {dOut, dOut, dIn, dIn}];
    
    chanPair[rhoA_, db_, jMt_] := Module[{da, dc, rhoBC, rhoB, rhoC},
        {dc, da} = Dimensions[jMt];
        dc = dc/db;
        If[Not[IntegerQ[dc]], 
            Return["chanPair called with incompatible isometry output dimension"]];
        rhoBC = jMt.rhoA.ConjugateTranspose[jMt];
        rhoB = qinf050`partrace[rhoBC, 2, {db, dc}];
        rhoC = qinf050`partrace[rhoBC, 1, {db, dc}];
        {rhoB, rhoC}];

    (*END chanPair*)

    choiToOp[choi_,dIn_,dOut_]:= Module[{choiTensor, chanTensor, chanMat},
        choiTensor = ket2kten[Flatten[choi], {dOut, dIn, dOut, dIn}];
        chanTensor = Transpose[choiTensor, {1, 3, 2, 4}];
        chanMat = ket2kten[Flatten[chanTensor],{dOut*dOut,dIn*dIn}];
        chanMat];

    (*END choiToOp*)

    choiToKraus[choi_, dIn_, dOut_] := Module[{u, w, v, kraus},
      {u, w, v} = SingularValueDecomposition[choi];
      wVec = Flatten[u.Sqrt[w]];
      wTen = ket2kten[wVec, {dOut, dIn, dOut*dIn}];
      kraus = Transpose[wTen, {2, 3, 1}];
      kraus];

    (*END choiToKraus*)

    krausComp[krAB_]:= Module[{krAC,ind,fun,da,db,dc},
        {dc,db,da}= Dimensions[krAB];
        krAC = {};
        For[ind=1,ind<=db, ++ind,
            fun[c_,a_]:= krAB[[c]][[ind,a]];
            AppendTo[krAC,Array[fun,{dc,da}]];
            ];
        krAC
        ];
    (*END krausComp*)

    krausToChanKet[krsAB_] := Module[{dc, db, da, vec}, 
        {dc, db, da} = Dimensions[krsAB];
        vec = ket2kten[Flatten[krsAB], {dc, db, da}]; 
        vec
        ];

    (*END krausToChanKet*)
 
    krausToChanMat[krsAB_] := Module[{chanTen, chanMat, dims, db, da},
        chanTen = krausToChanTen[krsAB];
        dims = Dimensions[chanTen];
        db = dims[[1]];
        da = dims[[3]];
        chanMat = ket2kten[Flatten[chanTen], {db*db, da*da}];
        chanMat
        ];

    (*END krausToChanMat*)

    krausToChanTen[krsLst_] := Module[{chanKet, bTensorBaBa, bTensorBBaa}, 
        chanKet = krausToChanKet[krsLst];
        bTensorBaBa = Inner[Times, chanKet, Conjugate[chanKet], Plus, 1]; 
        bTensorBBaa = Transpose[bTensorBaBa, {1, 3, 2, 4}]; 
        bTensorBBaa
        ];
    (*END krausToChanTen*)

    krausToChoi[krsAB_] := Module[{da, db, dc, chanKet, bTensorBaBa, choi},
        {dc, db, da} = Dimensions[krsAB];
        chanKet = krausToChanKet[krsAB];
        bTensorBaBa = Inner[Times, chanKet, Conjugate[chanKet], Plus, 1]; 
        choi = ket2kten[Flatten[bTensorBaBa], {db*da, db*db}];
        choi];
    (*END krausToChoi*)
    
    opToChoi[chanMat_, dIn_ ,dOut_]:= Module[{opTensor, choiTensor, choiMat},
        opTensor = ket2kten[Flatten[chanMat], {dOut, dOut, dIn, dIn}];
        choiTensor = Transpose[opTensor, {1, 3, 2, 4}];
        choiMat = ket2kten[Flatten[choiTensor], {dOut*dIn, dOut*dIn}];
        choiMat];
    (*END opToChoi*)
    
    randChanIso[da_, db_: 0, dc_: 0] := Module[{iso, dB, dC},
        If[db == 0, dB = da, dB = db];
        If[dc == 0, dC = da*dB, dC = dc];
        If[dc < 0 || db < 0 || da <= 0, 
        Return["randChan called with dimension zero or less"]];
        iso = randIso[da, dB*dC];
        iso]

    (*END randChanIso*)

    randIso[dI_, dO_] := Module[{mt, q, r},
      If[dO < dI, Return["Error:randIso[dI,dO] called with dO < dI"]];
      mt = RandomVariate[NormalDistribution[], {dO, dI}];
      mt = mt + I*RandomVariate[NormalDistribution[], {dO, dI}];
      mt = mt/Sqrt[2];
      {q, r} = QRDecomposition[mt];
      r = DiagonalMatrix[Diagonal[r]/Abs[Diagonal[r]]];
      ConjugateTranspose[q].r
      ];
    (*END randIso*)

End[]
EndPackage[]

