-- Ricky Tran
-- University of Florida
-- user_app_tb.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity user_app_tb is
end user_app_tb;

architecture tb of user_app_tb is
  type t_2d_a is array(0 to 63, 0 to 63) of integer range 0 to 255;
  constant input_key : t_2d_a :=
  ((    0,   238,    35,   209,   219,    61,    35,    94,     7,   251,   157,   245,    42,   114,   117,    33,     8,   102,   153,   187,     7,     1,    47,   185,    43,    63,    14,    84,    31,   246,   127,   249,    35,   119,    65,     0,   233,   109,     0,   218,   166,    56,   145,    22,    45,   129,    80,    26,   180,    77,   214,   160,    28,     0,    13,   165,     0,   114,   191,    50,    88,   142,    44,     8),
   (  238,     0,   234,    26,    10,    63,     0,   225,   109,   197,   212,   184,    57,   255,    56,    54,   237,     0,    47,     0,   207,   154,   154,   103,     7,     0,   240,   226,    13,   180,    19,   124,    61,   251,   154,   211,    60,    74,     8,     0,    24,   219,   253,   227,    32,   167,   142,     0,   121,   178,   180,   239,    24,     0,   161,   184,   167,    91,     2,     0,    12,    19,     0,    24),
   (   35,   234,     0,     0,   238,   128,   190,     0,   160,   137,   185,   131,   228,    56,    59,   211,    12,    67,   212,     5,    13,   186,    80,   236,   190,   209,     0,   191,     0,   252,   248,    90,    12,   102,    44,   195,    20,    42,     0,   201,     5,    27,     0,     6,     0,    15,    89,   142,    27,    59,    28,   219,   198,    16,   211,    89,    16,   128,   245,    87,   130,    83,   128,     0),
   (  209,    26,     0,     0,   188,   142,     0,     8,   169,   114,   153,   206,   138,   105,    19,    78,    72,    30,   224,    93,    67,    69,   229,   139,   122,    31,    90,   144,    14,     0,    25,   150,    15,   208,     0,    37,   180,    39,   110,   247,    16,   211,    24,    69,    15,    54,    40,   219,     0,   206,   208,    40,   140,   167,    97,     0,     6,   246,   182,   221,   185,     0,   126,     0),
   (  219,    10,   238,   188,     0,    20,    42,   196,    32,   120,    30,   233,   210,    55,   100,   245,   172,   170,    52,   194,   170,   129,    42,    92,   145,     0,   226,   219,   238,    57,   194,   226,    22,   173,   127,   116,   110,    70,     0,   155,   141,    95,   239,    15,    21,   155,   191,    82,    13,    48,     0,    20,   165,    42,   146,    30,   139,    37,   156,    99,   220,    47,    59,   188),
   (   61,    63,   128,   142,    20,     0,   132,   205,   156,   154,    60,     0,    94,   254,   108,    37,   196,   249,    42,   102,   179,   141,   213,   214,   240,    33,   115,    58,    66,   235,   108,   169,    49,   224,   232,   151,   160,   131,     0,   197,   172,     0,   200,   253,   154,    20,    83,   126,     0,   236,   109,   235,   137,   242,   211,     0,    95,   148,   179,   225,    86,    13,    14,    13),
   (   35,     0,   190,     0,    42,   132,     0,   150,    12,   202,     0,   148,   230,   163,   124,   167,   213,    71,    44,   103,    63,    11,    78,     0,   162,   122,   224,   159,   223,   208,   177,   182,   249,    23,   241,    73,   112,   225,   141,   169,     5,   198,   145,   188,     0,    94,   127,   173,   224,   124,   163,    30,    46,    14,   155,   164,   120,    89,   222,    69,   106,   211,   212,     0),
   (   94,   225,     0,     8,   196,   205,   150,     0,   183,    22,    78,    67,   206,    56,   105,   137,    34,   163,   199,   178,    10,   223,   250,    82,    16,   199,   138,    33,   110,    62,    69,   199,    98,   113,    68,    15,    74,   143,   245,   194,    15,    93,   187,   229,    58,   165,    53,     5,   138,   229,   226,   117,    36,     0,   178,     0,   210,   198,    94,   221,    83,   175,    33,   233),
   (    7,   109,   160,   169,    32,   156,    12,   183,     0,   156,   223,   178,   208,   127,    35,   162,   126,    89,   138,   196,   236,    33,   151,    90,    64,    36,    18,   107,   150,    48,   255,   242,   141,    67,    25,   194,   184,    93,   101,   121,   247,    65,   144,   201,   173,   135,    11,    71,   225,   184,   107,   244,    50,   168,   205,     0,   241,    67,    25,   139,     0,   198,   180,   248),
   (  251,   197,   137,   114,   120,   154,   202,    22,   156,     0,   158,   203,    76,    40,    90,    77,    59,    86,    54,   133,   116,   136,     0,     0,   186,    65,   241,    53,   177,   185,     0,    67,   238,   243,    48,   214,   212,   145,     7,   250,   250,     6,     0,     8,    26,   171,   218,    43,    26,   232,   131,    50,   206,   213,    92,   241,   134,     0,   208,    83,    56,    14,   163,   156),
   (  157,   212,   185,   153,    30,    60,     0,    78,   223,   158,     0,   143,    65,   159,   241,   134,    14,   215,    61,   150,   238,   232,    41,    19,   201,   142,   210,    71,   158,     1,    62,    58,     0,   208,   225,     0,   175,    90,     4,     0,   201,   233,   197,    34,    97,   167,   146,     0,    60,    81,    55,   225,    69,   239,   111,    93,    74,     0,    91,   254,   192,   147,   178,   191),
   (  245,   184,   131,   206,   233,     0,   148,    67,   178,   203,   143,     0,    87,    89,    71,     0,    81,    32,     0,   249,    63,   201,   203,   216,   178,    97,   234,   118,   131,   145,    71,   137,   247,     0,   111,     0,   214,     0,    93,   243,   177,    99,   215,    27,    35,    98,   100,    96,   191,    96,    56,    49,   222,    69,   129,   137,   131,   174,   159,    99,    19,   137,    52,     0),
   (   42,    57,   228,   138,   210,    94,   230,   206,   208,    76,    65,    87,     0,   178,   247,   215,   238,     0,    60,   180,    89,    19,   150,   242,    69,    21,   165,    66,    83,   207,    14,    77,   199,   168,   246,   160,    91,   197,   150,   106,     0,   201,    87,   128,   114,   226,    27,   154,   157,   136,    76,   207,    96,   163,    86,    48,   196,   211,     0,   186,   230,   182,   248,    72),
   (  114,   255,    56,   105,    55,   254,   163,    56,   127,    40,   159,    89,   178,     0,    66,   232,   133,     7,    14,   117,   216,    40,   165,     9,   243,   182,    85,   214,   164,   168,    72,   106,    42,    46,    17,   155,     8,    20,   161,   195,   115,    36,     0,    21,   230,   129,   241,     0,    96,    61,    90,    73,   118,   253,   171,     0,    54,   222,   219,   244,   109,     0,    57,   137),
   (  117,    56,    59,    19,   100,   108,   124,   105,    35,    90,   241,    71,   247,    66,     0,   218,   155,   206,    42,   183,   214,   178,   102,    46,    49,   250,   145,   119,    64,   172,     0,   134,   237,   142,   213,   249,     0,    25,   238,    97,     8,    12,   248,    17,    58,   194,    29,   155,   169,    19,     8,   224,    85,   254,   184,   243,    92,   126,    87,    84,   144,    25,   155,   144),
   (   33,    54,   211,    78,   245,    37,   167,   137,   162,    77,   134,     0,   215,   232,   218,     0,    17,   118,     0,   144,   164,    23,    91,   171,    23,   113,     0,     0,   211,   151,    64,   151,    59,   191,   108,    75,   211,     0,   119,     2,   116,     0,    38,   204,   212,    52,   241,   163,    18,   219,   238,   199,   101,     0,    28,    40,   203,     0,   141,    29,   197,   184,   140,     0),
   (    8,   237,    12,    72,   172,   196,   213,    34,   126,    59,    14,    81,   238,   133,   155,    17,     0,    12,   158,    52,    56,     0,   249,   112,    26,   187,    82,   228,    99,    19,   198,   201,   118,   209,    30,   212,   194,   122,   243,   237,    23,   115,    78,   116,   230,    54,    26,    94,    90,     0,   135,   183,   210,   135,   126,    81,   240,     0,   168,   144,   146,   164,   182,   230),
   (  102,     0,    67,    30,   170,   249,    71,   163,    89,    86,   215,    32,     0,     7,   206,   118,    12,     0,     0,     4,     0,   192,   215,   174,     0,   148,   216,   208,    80,     0,   233,    58,    64,   122,   199,   169,   246,   228,   121,     0,   178,    79,   142,   166,   166,    59,   226,   136,    10,   206,    64,   203,    97,   139,    49,    87,   148,     8,   113,    67,    93,    93,    30,    32),
   (  153,    47,   212,   224,    52,    42,    44,   199,   138,    54,    61,     0,    60,    14,    42,     0,   158,     0,     0,    45,   195,   237,    24,     0,    72,   208,   108,     0,    46,   147,    90,    45,   183,    61,   128,    71,   127,   233,   146,   130,    18,    64,    59,   235,     0,   204,   207,    46,   231,   254,     0,    84,   229,    70,   238,    35,   111,    84,   235,    97,   205,   117,   128,   144),
   (  187,     0,     5,    93,   194,   102,   103,   178,   196,   133,   150,   249,   180,   117,   183,   144,    52,     4,    45,     0,    31,     0,    15,   102,     0,   228,   210,    28,     0,   118,   203,   226,    84,    19,   180,   242,   161,    50,   230,    59,   173,    39,   116,    58,    93,    17,   112,    20,   203,   168,   221,    72,     0,    20,   157,   121,   205,   168,   103,   102,    53,    87,    53,    16),
   (    7,   207,    13,    67,   170,   179,    63,    10,   236,   116,   238,    63,    89,   216,   214,   164,    56,     0,   195,    31,     0,    80,   192,    27,   178,    52,   150,    49,     0,     0,   185,   102,   225,   180,   144,     0,   108,   203,   244,   240,   137,     0,   144,    88,     0,     4,   161,   193,   212,    63,   184,   179,   246,   167,    71,   224,   164,   127,   172,    74,    17,   216,   214,   173),
   (    1,   154,   186,    69,   129,   141,    11,   223,    33,   136,   232,   201,    19,    40,   178,    23,     0,   192,   237,     0,    80,     0,    10,    85,    45,    24,   249,    95,   163,   147,   224,    13,    42,   205,    26,     8,    91,   124,   148,    74,     0,    69,     0,    80,    63,     0,    92,   233,   166,   135,   169,    76,    72,   237,   173,    22,   147,    18,    31,   195,   178,    75,   124,   119),
   (   47,   154,    80,   229,    42,   213,    78,   250,   151,     0,    41,   203,   150,   165,   102,    91,   249,   215,    24,    15,   192,    10,     0,    31,   204,   172,   149,   160,   140,    79,     0,    66,   143,    27,     0,   207,     0,     0,    16,   230,   190,    76,   133,   143,    32,   205,   208,   176,   205,   136,   118,   147,   227,   201,   161,   154,   234,    99,    79,   100,    93,    93,   141,    23),
   (  185,   103,   236,   139,    92,   214,     0,    82,    90,     0,    19,   216,   242,     9,    46,   171,   112,   174,     0,   102,    27,    85,    31,     0,    29,   238,   193,     0,    22,   133,    38,    74,    32,    48,   224,   165,     0,   236,   183,   253,   158,   207,     0,   235,   188,   229,     0,   249,   204,    47,     0,    53,    47,     9,   118,    71,   237,   132,    41,   111,    94,    41,   166,    57),
   (   43,     7,   190,   122,   145,   240,   162,    16,    64,   186,   201,   178,    69,   243,    49,    23,    26,     0,    72,     0,   178,    45,   204,    29,     0,    57,     0,   222,    35,    37,   247,   190,    20,   204,   217,     2,   177,    12,   213,   194,   136,    66,    48,   133,     0,     0,    92,   246,    16,   133,   205,    84,    46,   169,   112,     6,   232,    89,    31,   146,    60,   242,    55,   222),
   (   63,     0,   209,    31,     0,    33,   122,   199,    36,    65,   142,    97,    21,   182,   250,   113,   187,   148,   208,   228,    52,    24,   172,   238,    57,     0,   166,   220,   225,     0,   105,   209,   128,    44,    19,    32,   132,   227,   199,     0,   138,    50,    49,    88,     6,   101,    84,   218,   182,    17,   255,     0,    48,    88,   159,     0,     2,   144,   171,    74,   202,    17,    11,     0),
   (   14,   240,     0,    90,   226,   115,   224,   138,    18,   241,   210,   234,   165,    85,   145,     0,    82,   216,   108,   210,   150,   249,   149,   193,     0,   166,     0,   250,   202,   110,   146,   167,   231,     9,   123,   145,    64,     0,   238,    55,    31,   136,    89,   222,   123,   106,    68,   220,    87,    82,   233,   209,   169,    22,     3,     0,    36,     4,    24,    92,    97,    84,   184,    45),
   (   84,   226,   191,   144,   219,    58,   159,    33,   107,    53,    71,   118,    66,   214,   119,     0,   228,   208,     0,    28,    49,    95,   160,     0,   222,   220,   250,     0,    39,   121,     0,    37,   200,   133,    49,   112,   150,     0,   114,   227,   230,   156,   104,   129,    21,   104,   139,   111,    24,   110,   122,    63,   245,   110,   168,     0,     5,    10,    84,   198,   216,     0,   145,   148),
   (   31,    13,     0,    14,   238,    66,   223,   110,   150,   177,   158,   131,    83,   164,    64,   211,    99,    80,    46,     0,     0,   163,   140,    22,    35,   225,   202,    39,     0,     0,    44,   140,   170,   149,   226,    26,    36,   204,    43,    20,    30,    14,   234,    55,   163,   123,   187,    51,   151,    19,    28,   110,    91,    50,    40,   236,     0,    72,    70,   109,   226,   126,   197,    99),
   (  246,   180,   252,     0,    57,   235,   208,    62,    48,   185,     1,   145,   207,   168,   172,   151,    19,     0,   147,   118,     0,   147,    79,   133,    37,     0,   110,   121,     0,     0,    23,    86,    56,   209,    71,   105,   252,   202,   127,   132,    64,    73,    26,    46,   236,   154,     8,   131,    47,   224,    43,    59,    54,     0,   225,   159,    42,   102,     9,   183,    56,     5,     3,   116),
   (  127,    19,   248,    25,   194,   108,   177,    69,   255,     0,    62,    71,    14,    72,     0,    64,   198,   233,    90,   203,   185,   224,     0,    38,   247,   105,   146,     0,    44,    23,     0,   121,   188,    21,   155,   248,   180,   212,   118,    25,    14,   100,    66,    97,   141,    56,   108,     0,   168,   240,   155,    15,    66,   212,     0,   195,    16,    36,   190,   254,   181,     0,    78,     0),
   (  249,   124,    90,   150,   226,   169,   182,   199,   242,    67,    58,   137,    77,   106,   134,   151,   201,    58,    45,   226,   102,    13,    66,    74,   190,   209,   167,    37,   140,    86,   121,     0,     9,   156,   159,   172,   195,   224,    52,    65,   225,    20,    83,   137,   126,    18,   243,   233,   146,   145,   226,   104,    72,   206,   140,   124,    38,   127,   203,    71,   133,   126,   122,    65),
   (   35,    61,    12,    15,    22,    49,   249,    98,   141,   238,     0,   247,   199,    42,   237,    59,   118,    64,   183,    84,   225,    42,   143,    32,    20,   128,   231,   200,   170,    56,   188,     9,     0,    89,   107,   135,   109,   201,     0,    95,   111,    65,     7,   186,   127,   121,   234,   211,    61,    30,   102,    35,    46,    58,   215,    70,     0,    24,   155,   113,   130,    56,   221,   201),
   (  119,   251,   102,   208,   173,   224,    23,   113,    67,   243,   208,     0,   168,    46,   142,   191,   209,   122,    61,    19,   180,   205,    27,    48,   204,    44,     9,   133,   149,   209,    21,   156,    89,     0,   124,   153,   135,   249,   226,   162,   140,     0,    62,   162,   173,   154,     0,   191,   198,   207,    97,     0,   214,    32,    95,    42,   175,   141,   106,    15,   204,    86,   203,   233),
   (   65,   154,    44,     0,   127,   232,   241,    68,    25,    48,   225,   111,   246,    17,   213,   108,    30,   199,   128,   180,   144,    26,     0,   224,   217,    19,   123,    49,   226,    71,   155,   159,   107,   124,     0,   100,    76,    57,   185,     3,    17,    91,    59,   208,    60,    88,    51,     8,     0,    14,   196,   153,   126,    56,    21,     0,   186,   157,   206,   195,   254,   176,   117,    17),
   (    0,   211,   195,    37,   116,   151,    73,    15,   194,   214,     0,     0,   160,   155,   249,    75,   212,   169,    71,   242,     0,     8,   207,   165,     2,    32,   145,   112,    26,   105,   248,   172,   135,   153,   100,     0,    54,   197,   181,   255,   238,   218,   251,   235,   106,    35,   180,    89,   215,   205,   106,   115,   146,   226,    29,    33,     4,   159,   231,    82,    58,   191,   192,   215),
   (  233,    60,    20,   180,   110,   160,   112,    74,   184,   212,   175,   214,    91,     8,     0,   211,   194,   246,   127,   161,   108,    91,     0,     0,   177,   132,    64,   150,    36,   252,   180,   195,   109,   135,    76,    54,     0,     4,    96,    15,     8,    29,    80,   115,   213,     0,    23,    84,   221,    79,   243,   201,   189,   234,   119,    59,    33,    54,   220,   125,   187,    87,   204,   209),
   (  109,    74,    42,    39,    70,   131,   225,   143,    93,   145,    90,     0,   197,    20,    25,     0,   122,   228,   233,    50,   203,   124,     0,   236,    12,   227,     0,     0,   204,   202,   212,   224,   201,   249,    57,   197,     4,     0,   209,    50,    13,    80,    99,   246,   172,    50,   136,   218,    47,   248,   160,   223,   169,    70,   134,   187,   239,   255,    34,   158,     0,   152,   182,   190),
   (    0,     8,     0,   110,     0,     0,   141,   245,   101,     7,     4,    93,   150,   161,   238,   119,   243,   121,   146,   230,   244,   148,    16,   183,   213,   199,   238,   114,    43,   127,   118,    52,     0,   226,   185,   181,    96,   209,     0,     0,    46,    91,   149,    83,   100,   168,     1,   180,   112,    56,     0,   144,   129,   243,   117,   232,    50,   150,    30,   220,    10,   180,   233,   103),
   (  218,     0,   201,   247,   155,   197,   169,   194,   121,   250,     0,   243,   106,   195,    97,     2,   237,     0,   130,    59,   240,    74,   230,   253,   194,     0,    55,   227,    20,   132,    25,    65,    95,   162,     3,   255,    15,    50,     0,     0,   150,   231,   131,    21,   227,   168,    23,   166,   180,    69,     0,     0,   124,   254,   152,    57,   232,   235,   167,    38,     0,    31,    75,    55),
   (  166,    24,     5,    16,   141,   172,     5,    15,   247,   250,   201,   177,     0,   115,     8,   116,    23,   178,    18,   173,   137,     0,   190,   158,   136,   138,    31,   230,    30,    64,    14,   225,   111,   140,    17,   238,     8,    13,    46,   150,     0,     0,    27,    71,     7,   236,   135,   231,     0,    44,    31,     0,   212,    87,   193,    83,    54,   239,     0,    47,     0,    77,   163,   122),
   (   56,   219,    27,   211,    95,     0,   198,    93,    65,     6,   233,    99,   201,    36,    12,     0,   115,    79,    64,    39,     0,    69,    76,   207,    66,    50,   136,   156,    14,    73,   100,    20,    65,     0,    91,   218,    29,    80,    91,   231,     0,     0,   141,     0,   178,    55,   204,   139,    12,   254,     0,   171,   128,    54,    79,   214,   160,     0,    78,     5,    17,   109,     0,   106),
   (  145,   253,     0,    24,   239,   200,   145,   187,   144,     0,   197,   215,    87,     0,   248,    38,    78,   142,    59,   116,   144,     0,   133,     0,    48,    49,    89,   104,   234,    26,    66,    83,     7,    62,    59,   251,    80,    99,   149,   131,    27,   141,     0,    56,    78,   154,   164,    10,   179,    93,    31,   174,    32,     0,    52,    43,   118,   147,   159,   154,     0,     4,     5,   218),
   (   22,   227,     6,    69,    15,   253,   188,   229,   201,     8,    34,    27,   128,    21,    17,   204,   116,   166,   235,    58,    88,    80,   143,   235,   133,    88,   222,   129,    55,    46,    97,   137,   186,   162,   208,   235,   115,   246,    83,    21,    71,     0,    56,     0,    44,    17,    67,    60,    11,     5,   119,   134,   132,   209,    89,   251,    40,   176,    42,   103,   143,    64,   228,   182),
   (   45,    32,     0,    15,    21,   154,     0,    58,   173,    26,    97,    35,   114,   230,    58,   212,   230,   166,     0,    93,     0,    63,    32,   188,     0,     6,   123,    21,   163,   236,   141,   126,   127,   173,    60,   106,   213,   172,   100,   227,     7,   178,    78,    44,     0,   192,   208,    49,     0,     0,   108,   193,   255,   253,    21,   128,   187,   241,     0,   193,    98,    39,   182,     1),
   (  129,   167,    15,    54,   155,    20,    94,   165,   135,   171,   167,    98,   226,   129,   194,    52,    54,    59,   204,    17,     4,     0,   205,   229,     0,   101,   106,   104,   123,   154,    56,    18,   121,   154,    88,    35,     0,    50,   168,   168,   236,    55,   154,    17,   192,     0,   249,   115,     0,    93,   132,    36,     0,   117,   148,    69,    90,     0,   127,   248,   244,   186,   153,   112),
   (   80,   142,    89,    40,   191,    83,   127,    53,    11,   218,   146,   100,    27,   241,    29,   241,    26,   226,   207,   112,   161,    92,   208,     0,    92,    84,    68,   139,   187,     8,   108,   243,   234,     0,    51,   180,    23,   136,     1,    23,   135,   204,   164,    67,   208,   249,     0,    26,   192,   138,    65,   108,    69,   180,    67,   155,    77,   125,    39,   124,   203,   237,    39,   126),
   (   26,     0,   142,   219,    82,   126,   173,     5,    71,    43,     0,    96,   154,     0,   155,   163,    94,   136,    46,    20,   193,   233,   176,   249,   246,   218,   220,   111,    51,   131,     0,   233,   211,   191,     8,    89,    84,   218,   180,   166,   231,   139,    10,    60,    49,   115,    26,     0,   166,    44,    45,   252,   203,   105,   170,    23,    89,   243,    90,    11,   111,   203,   224,   250),
   (  180,   121,    27,     0,    13,     0,   224,   138,   225,    26,    60,   191,   157,    96,   169,    18,    90,    10,   231,   203,   212,   166,   205,   204,    16,   182,    87,    24,   151,    47,   168,   146,    61,   198,     0,   215,   221,    47,   112,   180,     0,    12,   179,    11,     0,     0,   192,   166,     0,     0,     0,    73,    80,    49,    84,    89,    21,     0,   185,     4,   249,    99,     0,     0),
   (   77,   178,    59,   206,    48,   236,   124,   229,   184,   232,    81,    96,   136,    61,    19,   219,     0,   206,   254,   168,    63,   135,   136,    47,   133,    17,    82,   110,    19,   224,   240,   145,    30,   207,    14,   205,    79,   248,    56,    69,    44,   254,    93,     5,     0,    93,   138,    44,     0,     0,   180,     0,   194,   134,    53,    41,   161,   160,   214,   137,   180,    67,   176,   180),
   (  214,   180,    28,   208,     0,   109,   163,   226,   107,   131,    55,    56,    76,    90,     8,   238,   135,    64,     0,   221,   184,   169,   118,     0,   205,   255,   233,   122,    28,    43,   155,   226,   102,    97,   196,   106,   243,   160,     0,     0,    31,     0,    31,   119,   108,   132,    65,    45,     0,   180,     0,   229,   117,   179,   231,    25,     0,     0,     1,   107,   215,   113,    56,   226),
   (  160,   239,   219,    40,    20,   235,    30,   117,   244,    50,   225,    49,   207,    73,   224,   199,   183,   203,    84,    72,   179,    76,   147,    53,    84,     0,   209,    63,   110,    59,    15,   104,    35,     0,   153,   115,   201,   223,   144,     0,     0,   171,   174,   134,   193,    36,   108,   252,    73,     0,   229,     0,   109,   225,    81,   106,   221,   242,   238,   192,   246,    26,    26,   194),
   (   28,    24,   198,   140,   165,   137,    46,    36,    50,   206,    69,   222,    96,   118,    85,   101,   210,    97,   229,     0,   246,    72,   227,    47,    46,    48,   169,   245,    91,    54,    66,    72,    46,   214,   126,   146,   189,   169,   129,   124,   212,   128,    32,   132,   255,     0,    69,   203,    80,   194,   117,   109,     0,   142,   116,   136,   153,    27,   178,   196,     0,   204,    84,    93),
   (    0,     0,    16,   167,    42,   242,    14,     0,   168,   213,   239,    69,   163,   253,   254,     0,   135,   139,    70,    20,   167,   237,   201,     9,   169,    88,    22,   110,    50,     0,   212,   206,    58,    32,    56,   226,   234,    70,   243,   254,    87,    54,     0,   209,   253,   117,   180,   105,    49,   134,   179,   225,   142,     0,   164,   246,   131,    66,   130,   119,   187,   247,    43,    45),
   (   13,   161,   211,    97,   146,   211,   155,   178,   205,    92,   111,   129,    86,   171,   184,    28,   126,    49,   238,   157,    71,   173,   161,   118,   112,   159,     3,   168,    40,   225,     0,   140,   215,    95,    21,    29,   119,   134,   117,   152,   193,    79,    52,    89,    21,   148,    67,   170,    84,    53,   231,    81,   116,   164,     0,    20,    87,    78,   156,    95,     4,     0,   196,    44),
   (  165,   184,    89,     0,    30,     0,   164,     0,     0,   241,    93,   137,    48,     0,   243,    40,    81,    87,    35,   121,   224,    22,   154,    71,     6,     0,     0,     0,   236,   159,   195,   124,    70,    42,     0,    33,    59,   187,   232,    57,    83,   214,    43,   251,   128,    69,   155,    23,    89,    41,    25,   106,   136,   246,    20,     0,    47,    95,    45,   145,   226,    64,    92,   247),
   (    0,   167,    16,     6,   139,    95,   120,   210,   241,   134,    74,   131,   196,    54,    92,   203,   240,   148,   111,   205,   164,   147,   234,   237,   232,     2,    36,     5,     0,    42,    16,    38,     0,   175,   186,     4,    33,   239,    50,   232,    54,   160,   118,    40,   187,    90,    77,    89,    21,   161,     0,   221,   153,   131,    87,    47,     0,   195,   147,    69,   159,   113,   249,    67),
   (  114,    91,   128,   246,    37,   148,    89,   198,    67,     0,     0,   174,   211,   222,   126,     0,     0,     8,    84,   168,   127,    18,    99,   132,    89,   144,     4,    10,    72,   102,    36,   127,    24,   141,   157,   159,    54,   255,   150,   235,   239,     0,   147,   176,   241,     0,   125,   243,     0,   160,     0,   242,    27,    66,    78,    95,   195,     0,   144,    66,   226,    39,    88,    28),
   (  191,     2,   245,   182,   156,   179,   222,    94,    25,   208,    91,   159,     0,   219,    87,   141,   168,   113,   235,   103,   172,    31,    79,    41,    31,   171,    24,    84,    70,     9,   190,   203,   155,   106,   206,   231,   220,    34,    30,   167,     0,    78,   159,    42,     0,   127,    39,    90,   185,   214,     1,   238,   178,   130,   156,    45,   147,   144,     0,    21,    26,   126,   157,    30),
   (   50,     0,    87,   221,    99,   225,    69,   221,   139,    83,   254,    99,   186,   244,    84,    29,   144,    67,    97,   102,    74,   195,   100,   111,   146,    74,    92,   198,   109,   183,   254,    71,   113,    15,   195,    82,   125,   158,   220,    38,    47,     5,   154,   103,   193,   248,   124,    11,     4,   137,   107,   192,   196,   119,    95,   145,    69,    66,    21,     0,    28,   121,    89,     8),
   (   88,    12,   130,   185,   220,    86,   106,    83,     0,    56,   192,    19,   230,   109,   144,   197,   146,    93,   205,    53,    17,   178,    93,    94,    60,   202,    97,   216,   226,    56,   181,   133,   130,   204,   254,    58,   187,     0,    10,     0,     0,    17,     0,   143,    98,   244,   203,   111,   249,   180,   215,   246,     0,   187,     4,   226,   159,   226,    26,    28,     0,   118,     0,    22),
   (  142,    19,    83,     0,    47,    13,   211,   175,   198,    14,   147,   137,   182,     0,    25,   184,   164,    93,   117,    87,   216,    75,    93,    41,   242,    17,    84,     0,   126,     5,     0,   126,    56,    86,   176,   191,    87,   152,   180,    31,    77,   109,     4,    64,    39,   186,   237,   203,    99,    67,   113,    26,   204,   247,     0,    64,   113,    39,   126,   121,   118,     0,   196,   165),
   (   44,     0,   128,   126,    59,    14,   212,    33,   180,   163,   178,    52,   248,    57,   155,   140,   182,    30,   128,    53,   214,   124,   141,   166,    55,    11,   184,   145,   197,     3,    78,   122,   221,   203,   117,   192,   204,   182,   233,    75,   163,     0,     5,   228,   182,   153,    39,   224,     0,   176,    56,    26,    84,    43,   196,    92,   249,    88,   157,    89,     0,   196,     0,   139),
   (    8,    24,     0,     0,   188,    13,     0,   233,   248,   156,   191,     0,    72,   137,   144,     0,   230,    32,   144,    16,   173,   119,    23,    57,   222,     0,    45,   148,    99,   116,     0,    65,   201,   233,    17,   215,   209,   190,   103,    55,   122,   106,   218,   182,     1,   112,   126,   250,     0,   180,   226,   194,    93,    45,    44,   247,    67,    28,    30,     8,    22,   165,   139,     0));
   
  type key is array(0 to 63) of integer;
  constant answer_key : key :=
  ( 0, 1572882, 1310740, 3670035, 65564, 4128789, 1376268, 1310737, 7, 2490394, 1048598, 3932196, 1376276, 1114139, 2621464, 1376280, 8, 1048596, 2621474, 4128792, 7, 1, 1376267, 1310754, 2293771, 2883599, 14, 3670034, 31, 655383, 3670045, 1376270, 2031639, 1703959, 4128793, 1376265, 2621464, 1572887, 3014675, 983066, 2883600, 3866645, 2097182, 22, 4128777, 1310731, 524306, 458774, 3866644, 2818075, 3801109, 393258, 28, 393242, 13, 1572881, 2293773, 1703954, 65556, 4128784, 3538961, 1900572, 1638426, 8 );

  constant TEST_SIZE : integer := 128;
  constant MAX_CYCLES : integer  := TEST_SIZE*4;

  signal clk : std_logic := '0';
  signal rst : std_logic := '1';

  signal mmap_wr_en   : std_logic                         := '0';
  signal mmap_wr_addr : std_logic_vector(MMAP_ADDR_RANGE) := (others => '0');
  signal mmap_wr_data : std_logic_vector(MMAP_DATA_RANGE) := (others => '0');

  signal mmap_rd_en   : std_logic                         := '0';
  signal mmap_rd_addr : std_logic_vector(MMAP_ADDR_RANGE) := (others => '0');
  signal mmap_rd_data : std_logic_vector(MMAP_DATA_RANGE);

  signal sim_done : std_logic := '0';

begin

  UUT : entity work.user_app
    port map (
      clk          => clk,
      rst          => rst,
      mmap_wr_en   => mmap_wr_en,
      mmap_wr_addr => mmap_wr_addr,
      mmap_wr_data => mmap_wr_data,
      mmap_rd_en   => mmap_rd_en,
      mmap_rd_addr => mmap_rd_addr,
      mmap_rd_data => mmap_rd_data);

  -- toggle clock
  clk <= not clk after 5 ns when sim_done = '0' else clk;

  -- process to test different inputs
  process

    procedure clearMMAP is
    begin
      mmap_rd_en <= '0';
      mmap_wr_en <= '0';
    end clearMMAP;

    variable errors : integer := 0;

    variable result : std_logic_vector(C_MMAP_DATA_WIDTH-1 downto 0);
    variable done   : std_logic;
    variable count  : integer;

  begin
    report "============================SIMULATION START============================" severity note;
    -- reset circuit  
    rst <= '1';
    clearMMAP;
    wait for 200 ns;

    rst <= '0';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';

    -- write contents to input ram, which starts at addr 0
    for i in 0 to (TEST_SIZE / 4) - 1 loop
      mmap_wr_addr <= C_MEM_IN_SEL_ADDR;
      mmap_wr_en   <= '1';
      mmap_wr_data <= std_logic_vector(to_unsigned(i, C_MMAP_DATA_WIDTH));
      wait until clk'event and clk = '1';
      clearMMAP;
      for j in 0 to TEST_SIZE - 1 loop
        mmap_wr_addr <= std_logic_vector(to_unsigned(j, C_MMAP_ADDR_WIDTH));
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(input_key(4*i, j), 8) &
                                         to_unsigned(input_key(4*i+1, j), 8) &
                                         to_unsigned(input_key(4*i+2, j), 8) &
                                         to_unsigned(input_key(4*i+3, j), 8));
        wait until clk'event and clk = '1';
        clearMMAP;
      end loop;      
    end loop;

    -- send size
    mmap_wr_addr <= C_SIZE_ADDR;
    mmap_wr_en   <= '1';
    mmap_wr_data <= std_logic_vector(to_unsigned(TEST_SIZE, C_MMAP_DATA_WIDTH));
    wait until clk'event and clk = '1';
    clearMMAP;

    -- send src
    mmap_wr_addr <= C_SRC_ADDR;
    mmap_wr_en   <= '1';
    mmap_wr_data <= std_logic_vector(to_unsigned(0, C_MMAP_DATA_WIDTH));
    wait until clk'event and clk = '1';
    clearMMAP;

    ---- send go = 1 over memory map
    mmap_wr_addr <= C_GO_ADDR;
    mmap_wr_en   <= '1';
    mmap_wr_data <= std_logic_vector(to_unsigned(1, C_MMAP_DATA_WIDTH));
    wait until clk'event and clk = '1';
    clearMMAP;
    
    done  := '0';
    count := 0;

    -- read the done signal every cycle to see if the circuit has
    -- completed.
    --
    -- equivalent to wait until (done = '1') for TIMEOUT;      
    while done = '0' and count < MAX_CYCLES loop

      mmap_rd_addr <= C_DONE_ADDR;
      mmap_rd_en   <= '1';
      wait until clk'event and clk = '1';
      clearMMAP;
      -- give entity one cycle to respond
      wait until clk'event and clk = '1';
      done         := mmap_rd_data(0);
      count        := count + 1;
    end loop;

    if (done /= '1') then
      errors := errors + 1;
      report "Done signal not asserted before timeout.";
    end if;

    -- read outputs from output memory
    for i in 0 to TEST_SIZE-1 loop
      mmap_rd_addr   <= std_logic_vector(to_unsigned(i, C_MMAP_ADDR_WIDTH));
      mmap_rd_en     <= '1';            
      wait until clk'event and clk = '1';
      clearMMAP;
      -- give entity one cycle to respond
      wait until clk'event and clk = '1';
      result := mmap_rd_data;

      if (unsigned(result) /= answer_key(i)) then
        errors := errors + 1;
        report "Result for " & integer'image(i) &
          " is incorrect. The output is " &
          integer'image(to_integer(unsigned(result))) &
          " but should be " & integer'image(answer_key(i));
      end if;
    end loop;  -- i

    report "SIMULATION FINISHED!!!";
    report "TOTAL ERRORS : " & integer'image(errors);
    report "=============================SIMULATION END=============================" severity note;
    sim_done <= '1';
    wait;

  end process;
end tb;
