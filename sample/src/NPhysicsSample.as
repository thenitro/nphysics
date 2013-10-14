package {
	import com.thenitro.ngine.display.DocumentClass;
	import com.thenitro.nphysics.sample.SampleAABBImpulse;
	import com.thenitro.nphysics.sample.SampleCircleImpulse;
	
	[SWF(frameRate="60", width="1000",height="800")]
	public class NPhysicsSample extends DocumentClass {
		
		public function NPhysicsSample() {
			super(SampleAABBImpulse, true);
			//super(SampleCircleImpulse, true);
		};
	};
}