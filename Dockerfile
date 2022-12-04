# stage: build
# FROM --platform=${BUILDPLATFORM} alpine:3.17.0 as BUILD
FROM alpine:3.17.0 as BUILD

RUN set -x \
    && apk --update --no-cache add \
    build-base \
    git \
    libcurl \
    curl-dev \
    jansson-dev \
    bash \
    autoconf \
    openssl-dev \
    make \
    automake

WORKDIR /buildbase
RUN set -x \
    && git clone https://github.com/tpruvot/cpuminer-multi.git cpuminer

WORKDIR /buildbase/cpuminer
RUN set -x \
    && bash -x ./autogen.sh \
    # && ./configure CFLAGS="*-march=native*" --with-crypto --with-curl \
    && ./configure --with-crypto --with-curl \
    && make
    # && bash ./build.sh

# stage: release
# FROM --platform=${BUILDPLATFORM} alpine:3.17.0 as RELEASE
FROM alpine:3.17.0 as RELEASE

RUN set -x \
    && apk --update --no-cache add \
    libcurl \
    libgcc \
    libstdc++ \
    jansson \
    openssl

WORKDIR /cpuminer

COPY --from=BUILD /buildbase/cpuminer/cpuminer ./cpuminer

LABEL \
    type="cpuminer" \
    miner="cpuminer-multi" \
    maintainer="FilunK"

ENV ALGOLITHM=""
ENV THREADS=1
ENV USER=""
ENV PASSWORD=""
ENV URL=""

ENTRYPOINT /cpuminer/cpuminer --algo=${ALGOLITHM} --url=${URL} --user=${USER} --threads=${THREADS} --pass=${PASSWORD}

# Usage: cpuminer-multi [OPTIONS]
# Options:
#   -a, --algo=ALGO       specify the algorithm to use
#                           allium       Garlicoin double lyra2
#                           axiom        Shabal-256 MemoHash
#                           bitcore      Timetravel with 10 algos
#                           blake        Blake-256 14-rounds (SFR)
#                           blakecoin    Blake-256 single sha256 merkle
#                           blake2b      Blake2-B (512)
#                           blake2s      Blake2-S (256)
#                           bmw          BMW 256
#                           c11/flax     C11
#                           cryptolight  Cryptonight-light
#                           cryptonight  Monero
#                           decred       Blake-256 14-rounds 180 bytes
#                           dmd-gr       Diamond-Groestl
#                           drop         Dropcoin
#                           fresh        Fresh
#                           geek         GeekCash
#                           groestl      GroestlCoin
#                           heavy        Heavy
#                           jha          JHA
#                           keccak       Keccak (Old and deprecated)
#                           keccakc      Keccak (CreativeCoin)
#                           luffa        Luffa
#                           lyra2re      Lyra2RE
#                           lyra2rev2    Lyra2REv2
#                           lyra2v3      Lyra2REv3 (Vertcoin)
#                           myr-gr       Myriad-Groestl
#                           neoscrypt    NeoScrypt(128, 2, 1)
#                           nist5        Nist5
#                           pluck        Pluck:128 (Supcoin)
#                           pentablake   Pentablake
#                           phi          LUX initial algo
#                           phi2         LUX newer algo
#                           quark        Quark
#                           qubit        Qubit
#                           rainforest   RainForest (256)
#                           scrypt       scrypt(1024, 1, 1) (default)
#                           scrypt:N     scrypt(N, 1, 1)
#                           scrypt-jane:N (with N factor from 4 to 30)
#                           shavite3     Shavite3
#                           sha256d      SHA-256d
#                           sia          Blake2-B
#                           sib          X11 + gost (SibCoin)
#                           skein        Skein+Sha (Skeincoin)
#                           skein2       Double Skein (Woodcoin)
#                           sonoa        A series of 97 hashes from x17
#                           s3           S3
#                           timetravel   Timetravel (Machinecoin)
#                           vanilla      Blake-256 8-rounds
#                           x11evo       Permuted x11
#                           x11          X11
#                           x12          X12
#                           x13          X13
#                           x14          X14
#                           x15          X15
#                           x16r         X16R
#                           x16rv2       X16Rv2 (Raven / Trivechain)
#                           x16s         X16S (Pigeon)
#                           x17          X17
#                           x20r         X20R
#                           xevan        Xevan (BitSend)
#                           yescrypt     Yescrypt
#                           yescryptr8   Yescrypt r8
#                           yescryptr16  Yescrypt r16
#                           yescryptr32  Yescrypt r32
#                           zr5          ZR5
#   -o, --url=URL         URL of mining server
#   -O, --userpass=U:P    username:password pair for mining server
#   -u, --user=USERNAME   username for mining server
#   -p, --pass=PASSWORD   password for mining server
#       --cert=FILE       certificate for mining server using SSL
#   -x, --proxy=[PROTOCOL://]HOST[:PORT]  connect through a proxy
#   -t, --threads=N       number of miner threads (default: number of processors)
#   -r, --retries=N       number of times to retry if a network call fails
#                           (default: retry indefinitely)
#   -R, --retry-pause=N   time to pause between retries, in seconds (default: 30)
#       --time-limit=N    maximum time [s] to mine before exiting the program.
#   -T, --timeout=N       timeout for long poll and stratum (default: 300 seconds)
#   -s, --scantime=N      upper bound on time spent scanning current work when
#                           long polling is unavailable, in seconds (default: 5)
#       --randomize       Randomize scan range start to reduce duplicates
#   -f, --diff-factor     Divide req. difficulty by this factor (std is 1.0)
#   -m, --diff-multiplier Multiply difficulty by this factor (std is 1.0)
#   -n, --nfactor         neoscrypt N-Factor
#       --coinbase-addr=ADDR  payout address for solo mining
#       --coinbase-sig=TEXT  data to insert in the coinbase when possible
#       --max-log-rate    limit per-core hashrate logs (default: 5s)
#       --no-longpoll     disable long polling support
#       --no-getwork      disable getwork support
#       --no-gbt          disable getblocktemplate support
#       --no-stratum      disable X-Stratum support
#       --no-extranonce   disable Stratum extranonce support
#       --no-redirect     ignore requests to change the URL of the mining server
#   -q, --quiet           disable per-thread hashmeter output
#       --no-color        disable colored output
#   -D, --debug           enable debug output
#   -P, --protocol-dump   verbose dump of protocol-level activities
#       --hide-diff       Hide submitted block and net difficulty
#   -S, --syslog          use system log for output messages
#   -B, --background      run the miner in the background
#       --benchmark       run in offline benchmark mode
#       --cputest         debug hashes from cpu algorithms
#       --cpu-affinity    set process affinity to cpu core(s), mask 0x3 for cores 0 and 1
#       --cpu-priority    set process priority (default: 0 idle, 2 normal to 5 highest)
#   -b, --api-bind        IP/Port for the miner API (default: 127.0.0.1:4048)
#       --api-remote      Allow remote control
#       --max-temp=N      Only mine if cpu temp is less than specified value (linux)
#       --max-rate=N[KMG] Only mine if net hashrate is less than specified value
#       --max-diff=N      Only mine if net difficulty is less than specified value
#   -c, --config=FILE     load a JSON-format configuration file
#   -V, --version         display version information and exit
#   -h, --help            display this help text and exit
