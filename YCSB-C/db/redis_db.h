//
//  redis_db.h
//  YCSB-C
//

#ifndef YCSB_C_REDIS_DB_H_
#define YCSB_C_REDIS_DB_H_

#include "core/db.h"

#include <iostream>
#include <string>
#include "core/properties.h"
#include "redisclient.h"

using std::cout;
using std::endl;

namespace ycsbc {

  class RedisDB : public DB {
  public:
    RedisDB(const char *host, int start_port = 30001, int repeat_time = 6) {
     std::cout << "start connection" << std::endl;

     std::vector <redis::connection_data> redis_server;
//     int start_port = 30000;
     for (int i = 0; i < repeat_time; i++) {
      redis::connection_data con;
      con.host = std::string(host);
      con.port = start_port + i;
      con.dbindex = 14;
      redis_server.push_back(con);
//      redis_server.emplace_back(host, port + i);
     }


//     boost::shared_ptr <redis::client> cluster(
//         new redis::client(redis_server.begin(), redis_server.end())
//     );
     shared_c.reset(new redis::client(redis_server.begin(), redis_server.end()));
//     shared_c.reset(cluster);
    }

    int Read(const std::string &table, const std::string &key,
             const std::vector <std::string> *fields,
             std::vector <KVPair> &result);

    int Scan(const std::string &table, const std::string &key,
             int len, const std::vector <std::string> *fields,
             std::vector <std::vector<KVPair>> &result) { return 0; }

    int Update(const std::string &table, const std::string &key,
               std::vector <KVPair> &values);

    int Insert(const std::string &table, const std::string &key,
               std::vector <KVPair> &values) { return 0; }

    int Delete(const std::string &table, const std::string &key) { return 0; }

  private:
    boost::shared_ptr <redis::client> shared_c;
//        RedisCluster redis_;
  };

} // ycsbc
#endif // YCSB_C_REDIS_DB_H_

