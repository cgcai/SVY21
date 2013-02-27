import net.qxcg.svy21.*;
import java.util.Scanner;

public class TestDriver {
	private static final String COMMENT = "#";
	private static final String DELIMITER = ",";
	private static final int TC_LENGTH = 5;
	private static final int FCMP_PRECISION = 1000000000;
	
	public static void main(String[] args) {
		int line		= 0;
		int cases		= 0;
		int failures	= 0;
		String lineBuf;
		Scanner sc = new Scanner(System.in);
		
		while (sc.hasNextLine()) {
			// Read a line.
			line++;
			lineBuf = sc.nextLine();
			lineBuf = lineBuf.trim();
			
			// Ignore empty lines or comments.
			if (lineEmptyOrComment(lineBuf)) {
				continue;
			}
			
			// Split test case into tokens.
			String[] tokens = lineBuf.split(DELIMITER);
			if (tokens.length != TC_LENGTH) {
				continue;
			}
			
			// Trim each token.
			for (int i = 0; i < tokens.length; i++) {
				tokens[i] = tokens[i].trim();
			}
			
			// Parse input.
			// Pre-condition: the following inputs are assumed to be valid.
			int direction = Integer.parseInt(tokens[0]);
			double input1 = Double.parseDouble(tokens[1]);
			double input2 = Double.parseDouble(tokens[2]);
			double expected1 = Double.parseDouble(tokens[3]);
			double expected2 = Double.parseDouble(tokens[4]);
			cases++;
			
			// Perform conversion and unpack result.
			double result1, result2;
			if (direction == 0) {
				SVY21Coordinate conversionResult = SVY21.computeSVY21(input1, input2);
				result1 = conversionResult.getNorthing();
				result2 = conversionResult.getEasting();
			} else {
				LatLonCoordinate conversionResult = SVY21.computeLatLon(input1, input2);
				result1 = conversionResult.getLatitude();
				result2 = conversionResult.getLongitude();
			}
			
			if (fequals(result1, expected1) && fequals(result2, expected2)) {
				System.out.format("Line %d: pass\n", line);
			} else {
				System.out.format("Line %d: FAIL. Expected: (%f, %f) Got: (%f, %f)\n", line, expected1, expected2, result1, result2);
				failures++;
			}
		}
		
		System.out.format("Test complete. %d / %d passed, with %d failures.\n", (cases - failures), cases, failures);
	}
	
	private static boolean lineEmptyOrComment(String buffer) {
		return (buffer.isEmpty() || buffer.startsWith(COMMENT));
	}
	
	private static boolean fequals(double a, double b) {
		int num1 = (int)(a * FCMP_PRECISION);
		int num2 = (int)(b * FCMP_PRECISION);
		int diff = num1 - num2;
		return (diff >= -1 && diff <= 1);
	}
}
