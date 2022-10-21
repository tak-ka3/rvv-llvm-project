# https://msyksphinz.hatenablog.com/entry/2022/05/30/040000 でRISC-V Vector Extensionを試す

OLD := MMult0
NEW := MMult1

clang-14:= ../build/bin/clang-14
gcc := /home/hiraoka/riscv64_github/bin/riscv64-unknown-elf-gcc
objdump:= ../build/bin/llvm-objdump
riscv64-unknown-elf-objdump:= /home/hiraoka/riscv64_github/bin/riscv64-unknown-elf-objdump
spike:=/home/hiraoka/riscv64_github/bin/spike

SRCS = vector_test.c
OBJS = $(SRCS:.c=.o)
ASMS = $(SRCS:.c=.S)
ELFS = $(SRCS:.c=.elf)
TEST_OBJS := test_MMult.o
UTIL := copy_matrix.o compare_matrices.o random_matrix.o dclock.o REF_MMult.o print_matrix.o

%.o: %.c
	$(clang-14) -c $< -o $@ -menable-experimental-extensions -march=rv64gcv -target riscv64 -O3 -mllvm --riscv-v-vector-bits-min=256

# これはコマンドじゃないので一番上に書かれていても一番最初には実行されない
# .c.o: <- これのこと


all: clang

# clang
clang-obj: # target riscv64-unknown-elfが正しいのか、このままでいいのか？ # --riscv-v-vector-bits-min=の値はspike実行の時の--varch=ven:128と揃える必要がある。
	$(clang-14) -c $(SRCS) -o $(OBJS) -menable-experimental-extensions -march=rv64gcv -target riscv64 -O3 -mllvm --riscv-v-vector-bits-min=256

clang-asm: clang-obj
	$(riscv64-unknown-elf-objdump) -d $(OBJS) > $(ASMS)

clang-gcc-link: clang-asm $(TEST_OBJS) $(UTIL) # only link
	$(gcc) $(TEST_OBJS) $(OBJS) $(UTIL) -lc -o $(ELFS)

clang-spike: clang-gcc-link
	export OMP_NUM_THREADS=1
	export GOTO_NUM_THREADS=1
	$(spike) --varch=vlen:256,elen:64 --isa=rv64gcv pk $(ELFS)

clang: clang-spike

# gcc
gcc: $(SRCS)
	$(gcc) -O3 -march=rv64gcv $< -o $(ELFS)

gcc-obj:
	$(gcc) -O3 -march=rv64gcv -c $(SRCS) -o $(OBJS)

gcc-asm: gcc-obj
	$(riscv64-unknown-elf-objdump) -d $(OBJS) > $(ASMS)

$(ASMS): $(OBJS)
	$(riscv64-unknown-elf-objdump) -d $< > $@

gcc-spike: gcc gcc-asm
	$(spike) --varch=vlen:128,elen:64 --isa=rv64gcv pk $(ELFS)


clean: 
	rm -f $(OBJS) $(ASMS) $(ELFS) $(UTIL) $(TEST_OBJS)