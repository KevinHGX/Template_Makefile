#MACROS
CXX       = g++

INC_DIR   = ./inc
LIB_DIR   = ./lib
SRC_DIR   = ./src
BUILD_DIR = ./build
BIN_DIR   = ./bin

#----------------------CXXFLAGS----------------------------------
DEPFLAGS  = -MP -MD
CXXFLAGS  = -ggdb -O0 -Wall -Wextra $(addprefix -I,$(INC_DIR)) $(DEPFLAGS)

#---------------------- .EXE ------------------------------------
PROG_NAME = Application
.PHONY: ${PROG_NAME}

	#----------------------Project-----------------------------------
#all cpp
ALL_SRC_LIST = $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(LIB_DIR)/*.cpp) 

#cpp
SRC_LIST  = $(wildcard $(SRC_DIR)/*.cpp) 
LIB_LIST  = $(wildcard $(LIB_DIR)/*.cpp) 

#Objects
SRC_OBJ = $(addprefix $(BUILD_DIR)/,$(notdir $(SRC_LIST:.cpp=.o))) 
LIB_OBJ = $(addprefix $(BUILD_DIR)/,$(notdir $(LIB_LIST:.cpp=.o))) 

DEP_LIST  = $(addprefix $(BUILD_DIR)/,$(notdir $(ALL_SRC_LIST:.cpp=.d))) #dependencies

.PHONY: run
run: $(SRC_OBJ) $(LIB_OBJ) 

.PHONY: bin
bin: $(PROG_NAME) 

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

COMPILE.cc = ${CXX} $(CXXFLAGS) -c $< -o $@

#Regla implicita
$(SRC_OBJ): $(SRC_LIST) #Main.cpp
	@echo ">> Target $@ fired with deps $^..."
	$(CXX) $(CXXFLAGS) -c $< -o $@  

${BUILD_DIR}/%.o: ${LIB_DIR}/%.cpp
	@echo ">> Target $@ fired with deps $^..."
	${PRECOMPILE}
	${COMPILE.cc}
	${POSTCOMPILE}

#----------------------Create Bin-----------------------------------
#Regla explicita
$(PROG_NAME): $(SRC_OBJ) $(LIB_OBJ) 
	@echo ">> Generating executable $@"
	$(CXX) $(SRC_OBJ) $(LIB_OBJ) -o $(BIN_DIR)/$@ $(LIBS)

#----------------Clean Project----------------------
.PHONY: clean
clean:
	rm -f $(BIN_DIR)/$(PROG_NAME) $(BUILD_DIR)/*.o $(BUILD_DIR)/*.d 

#---------------------------------------------------------
# Let's include dependencies calculated by CC
-include $(DEPFLAGS)