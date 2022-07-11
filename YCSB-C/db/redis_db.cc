//
//  redis_db.cc
//  YCSB-C
//

#include "redis_db.h"

#include <cstring>

using namespace std;

namespace ycsbc {
  using namespace redis;

  int RedisDB::Read(const string &table, const string &key,
                    const vector <string> *fields,
                    vector <KVPair> &result) {
   if (fields) {
    string_vector results;
    shared_c->hmget(key, *fields, results);
    if (results.empty()) return DB::kOK;

    for (size_t i = 0; i < results.size(); i++) {
     result.push_back(make_pair(fields->at(i), results[i]));
    }
   } else {
    string_pair_vector results;
    shared_c->hgetall(key, results);
    if (results.size() == 0) return DB::kOK;
    for (size_t i = 0; i < results.size(); i++) {
     result.push_back(make_pair(results[i].first, results[i].second));
    }
   }
   return DB::kOK;
  }

  int RedisDB::Update(const string &table, const string &key,
                      vector <KVPair> &values) {
//   string_pair_vector values;

   shared_c->hmset(key, values);

   return DB::kOK;
  }

} // namespace ycsbc
