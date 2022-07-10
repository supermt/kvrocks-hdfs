//
//  redis_db.cc
//  YCSB-C
//

#include "redis_db.h"

#include <cstring>

using namespace std;

namespace ycsbc {

  int RedisDB::Read(const string &table, const string &key,
                    const vector <string> *fields,
                    vector <KVPair> &result) {
   return DB::kOK;
  }

  int RedisDB::Update(const string &table, const string &key,
                      vector <KVPair> &values) {
   return DB::kOK;
  }

} // namespace ycsbc
