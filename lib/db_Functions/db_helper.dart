import 'dart:convert';
import 'package:bustrackerapp/models/circuit.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:bustrackerapp/models/BusSchedule.dart';
import 'package:bustrackerapp/models/Bus.dart';
import 'package:mysql1/mysql1.dart';
import 'package:bustrackerapp/models/user.dart';
import 'package:bustrackerapp/models/station.dart';
import 'package:crypto/crypto.dart';

/*class DatabaseHelper {
  static const _host = 'inesay.marwagh.com';
   static const _port = 443;
  static const _user = 'inesay';
  static const _password = 'inesay1122//';
  static const _db = 'inesay';*/
class DatabaseHelper {
  static const _host = '192.168.29.204';
  static const _port = 3307;
  static const _user = 'alluser';
  static const _password = 'alluser';
  static const _db = 'bustracker';

  static MySqlConnection? _connection;

  static Future<MySqlConnection> getConnection() async {
    _connection ??= await MySqlConnection.connect(ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
      password: _password,
      db: _db,
    ));
    return _connection!;
  }

  static Future<User?> login(String email, String password) async {
    final conn = await getConnection();
    try {
      final results = await conn.query(
          'SELECT id, name, email, password, role FROM users WHERE email = ?',
          [email]);
      if (results.isNotEmpty) {
        final userMap = results.first.fields;
        final hashedPassword = userMap['password'] as String;
        if (hashedPassword == hashPassword(password)) {
          final int role = userMap['role'] as int;

          return User.fromJson(userMap);
        }
      }
    } finally {
      // await conn.close();
    }
    return null;
  }

  static Future<int?> register(
      String name, String email, String password) async {
    final conn = await getConnection();
    try {
      // Securely hash the password before storing
      final hashedPassword = hashPassword(password);

      final results = await conn.query(
          'INSERT INTO users (name, email, password , role ) VALUES (?, ?, ? ,0)',
          [name, email, hashedPassword]);

      return results.insertId;
    } finally {
     // await conn.close();
    }
  }

  // Implement a secure password hashing function (e.g., bcrypt)
  static String hashPassword(String password) {
    const salt = 'your_salt_here';
    const codec = Utf8Codec();
    final key = codec.encode(salt + password);
    final digest = sha256.convert(key);
    return digest.toString();
  }

  static Future<bool> checkEmailExists(String email) async {
    final conn = await getConnection();
    try {
      final results =
          await conn.query('SELECT id FROM users WHERE email = ?', [email]);
      return results.isNotEmpty;
    } finally {}
  }

  static Future<bool> resetPassword(String email, String newPassword) async {
    final conn = await getConnection();
    try {
      final results = await conn.query(
          'UPDATE users SET password = ? WHERE email = ?',
          [hashPassword(newPassword), email]);
      return results.affectedRows! > 0;
    } finally {}
  }

  //Admin Functions
  static Future<List<Station>> getStations() async {
    final conn = await getConnection();
    try {
      final results = await conn.query('SELECT * FROM stations');
      return results.map((e) => Station.fromJson(e.fields)).toList();
    } finally {
     // await conn.close();
    }
  }
  static Future<Station?> getStationById(int? id) async {
    final conn = await getConnection();
    try {
      final results = await conn.query('SELECT * FROM stations WHERE station_id = ?', [id]);
      if (results.isNotEmpty) {
        return Station.fromJson(results.first.fields);
      }
    } finally {
      // await conn.close();
    }
    return null;
  }

  static Future<void> addStation(Station station) async {
    final conn = await getConnection();
    try {
      await conn.query(
        'INSERT INTO stations (name, address, location,alt,lag) VALUES (?, ?, ?,?,?)',
        [station.name, station.address, station.location,station.Alt,station.Lag],
      );
    } finally {
      //await conn.close();
    }
  }


  static Future<void> editStation(int id, String newName,String newLocation, String newAddress , double NewAlt , double NewLag) async {
  final conn = await getConnection();
  try {
    await conn.query(
        'UPDATE stations SET name = ?,location=? , address = ? , alt=? , lag=?  WHERE station_id = ?',
        [newName, newLocation, newAddress , NewAlt , NewLag, id]);
  } finally {
    //await conn.close();
  }
}
  static Future<void> deleteStation(int? id) async {
    final conn = await getConnection();
    try {
      await conn.query('DELETE FROM stations WHERE station_id = ?', [id]);
    } catch (e) {
      print('Error deleting station: $e');
    } finally {
      //await conn.close();
    }
  }

  static Future<void> addBusSchedule(BusSchedule schedule) async {
    final conn = await getConnection();
    try {
      await conn.query(
        'INSERT INTO bus_schedules (station_id, bus_id, arrival_time, departure_time) VALUES (?, ?, ?, ?)',
        [schedule.stationId, schedule.busId, schedule.arrivalTime, schedule.departureTime],
      );
    } finally {
      //await conn.close();
    }
  }

  static Future<void> editBusSchedule(BusSchedule schedule) async {
    final conn = await getConnection();
    try {
      await conn.query(
        'UPDATE bus_schedules SET station_id = ?, bus_id = ?, arrival_time = ?, departure_time = ? WHERE id = ?',
        [schedule.stationId, schedule.busId, schedule.arrivalTime, schedule.departureTime, schedule.id],
      );
    } finally {
      //await conn.close();
    }
  }

  static Future<void> deleteBusSchedule(int id) async {
    final conn = await getConnection();
    try {
      await conn.query('DELETE FROM bus_schedules WHERE id = ?', [id]);
    } catch (e) {
      print('Error deleting bus schedule: $e');
    } finally {
      //await conn.close();
    }
  }

  static Future<List<BusSchedule>> getBusSchedulesForStation(int stationId) async {
    final conn = await getConnection();
    try {
      final results = await conn.query('SELECT * FROM bus_schedules WHERE station_id = ?', [stationId]);
      return results.map((e) => BusSchedule.fromJson(e.fields)).toList();
    } finally {
      //await conn.close();
    }
  }

  static Future<List<Bus>> getBuses() async {
    final conn = await getConnection();
    try {
      final results = await conn.query('SELECT * FROM buses');
      return results.map((e) => Bus.fromJson(e.fields)).toList();
    } finally {
      //await conn.close();
    }
  }

  static Future<void> addbus(Bus bus) async {
    final conn = await getConnection();
    try {
      await conn.query(
        'INSERT INTO buses (registration_number, model) VALUES (?, ?)',
        [bus.registrationNumber, bus.model],
      );
    } finally {
      //await conn.close();
    }
  }
  static Future<void> deletebus(int? id) async {
    final conn = await getConnection();
    try {
      await conn.query('DELETE FROM buses WHERE bus_id = ?', [id]);
    } catch (e) {
      print('Error deleting bus: $e');
    } finally {
      //await conn.close();
    }
  }
  static Future<Bus?> getBusById(int? id) async {
    final conn = await getConnection();
    try {
      final results = await conn.query('SELECT * FROM buses WHERE Bus_id = ?', [id]);
      if (results.isNotEmpty) {
        return Bus.fromJson(results.first.fields);
      }
    } finally {
      // await conn.close();
    }
    return null;
  }

  static Future<void> editBus(int id, String newNumber,String newModel) async {
    final conn = await getConnection();
    try {
      await conn.query(
          'UPDATE buses SET registration_number = ?,model=?  WHERE bus_id = ?',
          [newNumber, newModel, id]);
    } finally {
      //await conn.close();
    }
  }
  static Future<List<Circuit>> getCircuits() async {
    final conn = await getConnection();
    try {
      final results = await conn.query('SELECT * FROM circuit');
      return results.map((e) => Circuit.fromJson(e.fields)).toList();
    } finally {
      // await conn.close();
    }
  }



  static Future<int> addCircuit(Circuit circuit) async {
    final conn = await getConnection();
    try {
      await conn.query(
        'INSERT INTO circuit (name) VALUES (?)',
        [circuit.name],
      );
      final result = await conn.query('SELECT LAST_INSERT_ID() as id');
      final insertedId = result.first.fields['id'] as int;
      return insertedId;
    } finally {

    }
  }


  static Future<void> deleteCircuit(int? id) async {
    final conn = await getConnection();
    try {
      // Start a transaction to ensure both operations complete successfully
      await conn.transaction((transaction) async {
        // First, delete entries in the circuitstations table
        await transaction.query('DELETE FROM circuitstations WHERE circuit_id = ?', [id]);
        // Next, delete the circuit itself
        await transaction.query('DELETE FROM circuit WHERE id = ?', [id]);
      });
    } catch (e) {
      print('Error deleting circuit and related stations: $e');
    } finally {

    }
  }


  static Future<List<int>> getStationIdsForCircuit(int? id) async {
  final conn = await getConnection();
  try {
    final results = await conn.query('SELECT station_id FROM circuitstations WHERE circuit_id = ?', [id]);
    return results.map((e) => e.fields['station_id'] as int).toList();
  } finally {
    // await conn.close(); // Make sure to close the connection
  }
}

  static Future<void> addCircuitStation(int circuitId, List<int> stationIds) async {
    final conn = await getConnection();
    try {
      for (final stationId in stationIds) {
        await conn.query('INSERT INTO circuitstations (circuit_id, station_id) VALUES (?, ?)', [circuitId, stationId]);
      }
    } finally {
      // await conn.close();
    }
  }

// Assuming your DatabaseHelper has a method like this to fetch station names
  static Future<List<String>> getStationNamesForCircuit(int circuitId) async {
    final conn = await getConnection();
    List<String> stationNames = [];
    try {
      final result = await conn.query(
          'SELECT stations.name FROM stations '
              'JOIN circuitstations ON stations.station_id = circuitstations.station_id '
              'WHERE circuitstations.circuit_id = ?',
          [circuitId]
      );
      for (var row in result) {
        stationNames.add(row[0] as String);
      }
    } finally {

    }
    return stationNames;
  }


}
